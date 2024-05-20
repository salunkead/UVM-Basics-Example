//run_phase with sub phase execution behaviour
/*
1.here both run_phase and sub_phase(reset,configure,main,shut_down phase) run parallely
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
  endfunction
  
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    #5;
    `uvm_info(get_type_name,"Entered in reset phase",UVM_NONE);
    phase.drop_objection(this);
  endtask
  
  task configure_phase(uvm_phase phase);
    phase.raise_objection(this);
    #5;
     `uvm_info(get_type_name,"Entered in configuration phase",UVM_NONE);
    phase.drop_objection(this);
  endtask
  
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    #5;
     `uvm_info(get_type_name,"Entered in main phase",UVM_NONE);
    phase.drop_objection(this);
  endtask
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #15;
    `uvm_info(get_type_name,"Entered in run phase",UVM_NONE);
    phase.drop_objection(this);
  endtask
  
  task shutdown_phase(uvm_phase phase);
    phase.raise_objection(this);
    #5;
    `uvm_info(get_type_name,"Entered in shutdown phase",UVM_NONE);
    phase.drop_objection(this);
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(get_type_name,"Extract phase execution",UVM_NONE);
  endfunction
endclass

module top;
  initial
    run_test("comp1");
endmodule
