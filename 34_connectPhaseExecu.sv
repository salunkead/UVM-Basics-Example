//Execution flow of connect phase of multiple components

//Code-1 connect phase of the components executes from bottom to top(child to parent)
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
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name,"DRIVER class connect phase",UVM_NONE);
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
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name,"MONITOR class connect phase",UVM_NONE);
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
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name,"ENV class connect phase",UVM_NONE);
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
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name,"TEST class connect phase",UVM_NONE);
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
