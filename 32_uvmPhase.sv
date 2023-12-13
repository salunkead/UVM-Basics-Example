//The UVM_PHASE class synchronization methods 
/*
1.Synchronization methods of UVM_PHASE class
  1.virtual function void raise_objection (uvm_object obj,string description="",int count=1)
    1.this method plays important role in managing the flow of the phases and ensuring proper synchronization between components.
    2.this method is typically called when component needs to indicate that it is not yet ready to terminate.it increments an objection counter.
    3.if the objection is raised with delay,it might represent a situation where component needs to wait for some event to occure before proceeding for next phase.
  2.virtual function void drop_objection (uvm_object obj,string description="",int count=1)
    1.this method is called to indicate that the component is ready to terminate.it decrements the objection counter
*/

//Code-1 - without synchronization method raise_objection and drop_objection
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp extends uvm_component;
  `uvm_component_utils(comp)
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
  endfunction
  task reset_phase(uvm_phase phase);
    `uvm_info("reset_phase","before delay",UVM_NONE);
    #10;
    `uvm_info("reset_phase","after delay",UVM_NONE);
  endtask
  task configure_phase(uvm_phase phase);
    `uvm_info("configure_phase","before delay",UVM_NONE);
    #10;
    `uvm_info("configure_phase","after delay",UVM_NONE);
  endtask
  task main_phase(uvm_phase phase);
    `uvm_info("main_phase","before delay",UVM_NONE);
    #10;
    `uvm_info("main_phase","after delay",UVM_NONE);
  endtask
  task shutdown_phase(uvm_phase phase);
    `uvm_info("shut_phase","before delay",UVM_NONE);
    #10;
    `uvm_info("shut_phase","after delay",UVM_NONE);
  endtask
endclass

module test;
  initial run_test("comp");
endmodule

//Code-2 with synchronization method raise_objection and drop_objection
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp extends uvm_component;
  `uvm_component_utils(comp)
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
  endfunction
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("reset_phase","before delay",UVM_NONE);
    #10;
    `uvm_info("reset_phase","after delay",UVM_NONE);
    phase.drop_objection(this);
  endtask
  task configure_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("configure_phase","before delay",UVM_NONE);
    #10;
    `uvm_info("configure_phase","after delay",UVM_NONE);
    phase.drop_objection(this);
  endtask
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("main_phase","before delay",UVM_NONE);
    #10;
    `uvm_info("main_phase","after delay",UVM_NONE);
    phase.drop_objection(this);
  endtask
  task shutdown_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("shut_phase","before delay",UVM_NONE);
    #10;
    `uvm_info("shut_phase","after delay",UVM_NONE);
    phase.drop_objection(this);
  endtask
endclass

module test;
  initial run_test("comp");
endmodule
