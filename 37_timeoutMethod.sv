//The simulation control method of uvm_root class - set_timeout()
/*
1.declaration of the method:-
   function void set_timeout(time timeout,bit overridable=1)
2.The timeout is simply the maximum absolute simulation time allowed before a FATAL occurs.
  If the timeout is set to 20ns, then the simulation must end before 20ns, or a FATAL timeout will occur.
3.This is provided so that the user can prevent the simulation from potentially consuming too many resources (Disk, Memory, CPU, etc) when the testbench is essentially hung.
*/

//Code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  function new(string n="driver",uvm_component p=null);
    super.new(n,p);
  endfunction
  time t;
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_name,"run_phase before delay",UVM_NONE);
    #10;
    `uvm_info(get_name,"run_phase after delay",UVM_NONE);
    phase.drop_objection(this);
  endtask
endclass

module test;
  initial 
    begin
      uvm_top.set_timeout(5);
      run_test("driver");
    end
endmodule
