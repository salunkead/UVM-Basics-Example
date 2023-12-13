//Execution flow of built_phase of multiple components
/*
1.components used in below code and their declaration in uvm
  1.class uvm_driver #(type REQ=uvm_sequence_item,type RSP=REQ) extends uvm_component
    1.methdos and ports:-
      1.function new (string name,uvm_component parent) ->
      2.ports
        1.seq_item_port	:-Derived driver classes should use this port to request items from the sequencer.
        2.rsp_port	:-This port provides an alternate way of sending responses back to the originating sequencer.
2.virtual class uvm_monitor extends uvm_component
  1.methods:- only one method -> function new (string name,uvm_component parent)
3.virtual class uvm_env extends uvm_component
  1.methods:- only one method -> function new (string name,uvm_component parent)
4.virtual class uvm_test extends uvm_component 
  1.methods:- only one method -> function new (string name,uvm_component parent)

*/

//Code-1 :- from the topology, you can get that the execution flow of the build phase of multiple components starts from top to bottom
`include "uvm_macros.svh"
import uvm_pkg::*;
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  function new(string n="driver",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name,"driver class build phase",UVM_NONE);
  endfunction
endclass
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string n="monitor",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name,"monitor class build phase",UVM_NONE);
  endfunction
endclass
class env extends uvm_env;
  `uvm_component_utils(env)
  driver drv;
  monitor mon;
  function new(string n="env",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=driver::type_id::create("drv",this);
    mon=monitor::type_id::create("mon",this);
    `uvm_info(get_name,"env class build phase",UVM_NONE);
  endfunction
endclass
class test extends uvm_test;
  `uvm_component_utils(test)
  env e;
  function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e=env::type_id::create("e",this);
    `uvm_info(get_name,"test class build phase",UVM_NONE);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology(uvm_default_tree_printer);
  endfunction
endclass

module top;
  initial 
    begin
      run_test("test");
    end
endmodule
