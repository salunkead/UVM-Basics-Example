//Execution flow of time consuming phases

//Code-all the time consuming phases of the components executes parallely.
`include "uvm_macros.svh"
import uvm_pkg::*;
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("reset_phase",$sformatf("DRIVER CLASS-starts at t=%0t",$time),UVM_NONE);
    #10;
    `uvm_info("reset_phase",$sformatf("DRIVER CLASS-ends at t=%0t",$time),UVM_NONE);
    phase.drop_objection(this);
  endtask
  task configure_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("configure_phase",$sformatf("DRIVER CLASS-starts at t=%0t",$time),UVM_NONE);
    #10;
    `uvm_info("configure_phase",$sformatf("DRIVER CLASS-ends at t=%0t",$time),UVM_NONE);
    phase.drop_objection(this);
  endtask
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("main_phase",$sformatf("DRIVER CLASS-starts at t=%0t",$time),UVM_NONE);
    #10;
    `uvm_info("main_phase",$sformatf("DRIVER CLASS-ends at t=%0t",$time),UVM_NONE);
    phase.drop_objection(this);
  endtask
  task shutdown_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("shutdown_phase",$sformatf("DRIVER CLASS-starts at t=%0t",$time),UVM_NONE);
    #10;
    `uvm_info("shutdown_phase",$sformatf("DRIVER CLASS-ends at t=%0t",$time),UVM_NONE);
    phase.drop_objection(this);
  endtask
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string n="mon",uvm_component p=null);
    super.new(n,p);
  endfunction
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("reset_phase",$sformatf("MONITOR CLASS-starts at t=%0t",$time),UVM_NONE);
    #10;
    `uvm_info("reset_phase",$sformatf("MONITOR CLASS-end at t=%0t",$time),UVM_NONE);
    phase.drop_objection(this);
  endtask
  task configure_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("configure_phase",$sformatf("MONITOR CLASS-starts at t=%0t",$time),UVM_NONE);
    #10;
    `uvm_info("configure_phase",$sformatf("MONITOR CLASS-end at t=%0t",$time),UVM_NONE);
    phase.drop_objection(this);
  endtask
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("main_phase",$sformatf("MONITOR CLASS-starts at t=%0t",$time),UVM_NONE);
    #10;
    `uvm_info("main_phase",$sformatf("MONITOR CLASS-end at t=%0t",$time),UVM_NONE);
    phase.drop_objection(this);
  endtask
  task shutdown_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("shutdown_phase",$sformatf("MONITOR CLASS-starts at t=%0t",$time),UVM_NONE);
    #10;
    `uvm_info("shutdown_phase",$sformatf("MONITOR CLASS-end at t=%0t",$time),UVM_NONE);
    phase.drop_objection(this);
  endtask
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
  endfunction
endclass

module test;
  initial run_test("env");
endmodule
