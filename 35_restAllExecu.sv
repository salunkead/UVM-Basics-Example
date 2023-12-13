//Execution flow of NON-TIME CONSUMING PHASES

//build_phase and final_phase executes from top to down(parent to child) and rest all bottom to up(child to parent)
`include "uvm_macros.svh"
import uvm_pkg::*;
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  function new(string n="driver",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name,"DRIVER class BUILD PHASE",UVM_NONE);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name,"DRIVER class CONNECT PHASE",UVM_NONE);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_name,"DRIVER class END_OF_ELABORATION_PHASE",UVM_NONE);
  endfunction
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(get_name,"DRIVER class START_OF_SIMULATION",UVM_NONE);
  endfunction
  function void extract_phase(uvm_phase phase);
     super.extract_phase(phase);
    `uvm_info(get_name,"DRIVER class EXTRACT_PHASE",UVM_NONE);
  endfunction
  function void check_phase(uvm_phase phase);
     super.check_phase(phase);
    `uvm_info(get_name,"DRIVER class CHECK_PHASE",UVM_NONE);
  endfunction
  function void report_phase(uvm_phase phase);
     super.report_phase(phase);
    `uvm_info(get_name,"DRIVER class REPORT_PHASE",UVM_NONE);
  endfunction
  function void final_phase(uvm_phase phase);
     super.final_phase(phase);
    `uvm_info(get_name,"DRIVER class FINAL_PHASE",UVM_NONE);
  endfunction
endclass
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string n="monitor",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name,"MONITOR class BUILD_PHASE",UVM_NONE);
    $display("----------------------------------------------");
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name,"MONITOR class CONNECT_PHASE",UVM_NONE);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_name,"MONITOR class END_OF_ELABORATION_PHASE",UVM_NONE);
  endfunction
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(get_name,"MONITOR class START_OF_SIMULATION",UVM_NONE);
  endfunction
  function void extract_phase(uvm_phase phase);
     super.extract_phase(phase);
    `uvm_info(get_name,"MONITOR class EXTRACT_PHASE",UVM_NONE);
  endfunction
  function void check_phase(uvm_phase phase);
     super.check_phase(phase);
    `uvm_info(get_name,"MONITOR class CHECK_PHASE",UVM_NONE);
  endfunction
  function void report_phase(uvm_phase phase);
     super.report_phase(phase);
    `uvm_info(get_name,"MONITOR class REPORT_PHASE",UVM_NONE);
  endfunction
  function void final_phase(uvm_phase phase);
     super.final_phase(phase);
    `uvm_info(get_name,"MONITOR class FINAL_PHASE",UVM_NONE);
     uvm_top.print_topology(uvm_default_tree_printer);
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
    `uvm_info(get_name,"ENV class BUILD_PHASE",UVM_NONE);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name,"ENV class CONNECT_PHASE",UVM_NONE);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_name,"ENV class END_OF_ELABORATION_PHASE",UVM_NONE);
  endfunction
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(get_name,"ENV class START_OF_SIMULATION",UVM_NONE);
  endfunction
  function void extract_phase(uvm_phase phase);
     super.extract_phase(phase);
    `uvm_info(get_name,"ENV class EXTRACT_PHASE",UVM_NONE);
  endfunction
  function void check_phase(uvm_phase phase);
     super.check_phase(phase);
    `uvm_info(get_name,"ENV class CHECK_PHASE",UVM_NONE);
  endfunction
  function void report_phase(uvm_phase phase);
     super.report_phase(phase);
    `uvm_info(get_name,"ENV class REPORT_PHASE",UVM_NONE);
  endfunction
  function void final_phase(uvm_phase phase);
     super.final_phase(phase);
    `uvm_info(get_name,"ENV class FINAL_PHASE",UVM_NONE);
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
    `uvm_info(get_name,"TEST class BUILD_PHASE",UVM_NONE);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name,"TEST class CONNECT_PHASE",UVM_NONE);
    $display("---------------------------------------------");
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_name,"TEST class END_OF_ELABORATION_PHASE",UVM_NONE);
     $display("---------------------------------------------");
  endfunction
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info(get_name,"TEST class START_OF_SIMULATION",UVM_NONE);
     $display("---------------------------------------------");
  endfunction
  function void extract_phase(uvm_phase phase);
     super.extract_phase(phase);
    `uvm_info(get_name,"TEST class EXTRACT_PHASE",UVM_NONE);
     $display("---------------------------------------------");
  endfunction
  function void check_phase(uvm_phase phase);
     super.check_phase(phase);
    `uvm_info(get_name,"TEST class CHECK_PHASE",UVM_NONE);
     $display("---------------------------------------------");
  endfunction
  function void report_phase(uvm_phase phase);
     super.report_phase(phase);
    `uvm_info(get_name,"TEST class REPORT_PHASE",UVM_NONE);
     $display("---------------------------------------------");
  endfunction
  function void final_phase(uvm_phase phase);
     super.final_phase(phase);
    `uvm_info(get_name,"TEST class FINAL_PHASE",UVM_NONE);
  endfunction
endclass

module top;
  initial 
      run_test("test");
endmodule
