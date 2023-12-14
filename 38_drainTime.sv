//use of set_drain_time() method in single component
/*
1.set_drain_time method allows you to specify the amount of time to wait after raising an objection before droping it automatically.
2.in code-2,the drain time is set to 20 time unit,meaning objections are dropped after 20 time unit after they raised.
3.the default drain time is 0,meaning objection are droppped immediatly after they are raised.
*/

//Code-1 without drain time 
`include "uvm_macros.svh"
import uvm_pkg::*;
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    $display("reset phase started at t=%0t",$time);
    #10;
    phase.drop_objection(this);
  endtask
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    $display("main_phase started at t=%0t",$time);
    #5;
    phase.drop_objection(this);
  endtask
endclass

module test;
  initial 
    begin
      run_test("driver");
    end
endmodule

//Code-2 with drain time of 20 time unit
`include "uvm_macros.svh"
import uvm_pkg::*;
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  task reset_phase(uvm_phase phase);
    phase.phase_done.set_drain_time(this,20);
    phase.raise_objection(this);
    $display("reset phase started at t=%0t",$time);
    #10;
    phase.drop_objection(this);
  endtask
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    $display("main_phase started at t=%0t",$time);
    #5;
    phase.drop_objection(this);
  endtask
endclass

module test;
  initial 
    begin
      run_test("driver");
    end
endmodule
