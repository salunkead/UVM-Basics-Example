//Execution flow when there are multiple components with drain time set in single component.

//Code-1
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
    $display("Driver ","reset phase started at t=%0t",$time);
    #10;
    $display("Driver ","reset phase ended at t=%0t",$time);
    phase.drop_objection(this);              //objection raised by reset phase is droped at t=10+drain_time=10+20=30 time unit
  endtask
  task main_phase(uvm_phase phase);          //main phase starts at t=30 time unit
    phase.raise_objection(this);
    $display("Driver ","main_phase started at t=%0t",$time);
    #5;
    $display("Driver ","main phase ended at t=%0t",$time);
    phase.drop_objection(this);
  endtask
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string n="mon",uvm_component p=null);
    super.new(n,p);
  endfunction
  task main_phase(uvm_phase phase); //main of monior will also starts at t=30 time unit
    phase.raise_objection(this);
    $display("Monitor ","main_phase started at t=%0t",$time);
    #5;
    $display("Monitor ","main phase ended at t=%0t",$time);
    phase.drop_objection(this);
  endtask
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  function new(string n="env",uvm_component p=null);
    super.new(n,p);
  endfunction
  driver drv;
  monitor mon;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=driver::type_id::create("drv",this);
    mon=monitor::type_id::create("mon",this);
  endfunction
endclass

module test;
  initial 
    begin
      run_test("env");
    end
endmodule
