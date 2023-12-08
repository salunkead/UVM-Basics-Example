//Changing verbosity level of the hierarchy
/*
1.the this keyword is used as the parent component when creating the objects of driver and monitor,indicating that the env is the parent of driver and monitor
2. heirarchy here is 
        uvm_root
            |
           env
           /  \
        driver monitor
3.we can change the verbosity of the hierarchy by using:- set_report_verbosity_level_hier(verbosity_level_to_be_set) method
*/

//code-1 before changing verbosity of the hierarchy
`include "uvm_macros.svh"
import uvm_pkg::*;
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("drv","driver class message-1",UVM_HIGH);
    `uvm_info("drv1","driver class message-2",UVM_HIGH);
  endtask
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string n="mon",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("mon","monitor class message-1",UVM_HIGH);
    `uvm_info("mon1","monitor class message-2",UVM_HIGH);
  endtask
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  driver drv;
  monitor mon;
  function new(string n="env",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    drv=new("drv",this); //driver and monitor are the childs of the env class
    mon=new("mon",this);
    drv.run;
    mon.run;
  endtask
endclass

module test;
  env e;
  initial
    begin
      e=new("e",null);
      e.run;
    end
endmodule

//code-2 after changing the verbosity of the hierarchy
`include "uvm_macros.svh"
import uvm_pkg::*;
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("drv","driver class message-1",UVM_HIGH);
    `uvm_info("drv1","driver class message-2",UVM_HIGH);
  endtask
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string n="mon",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("mon","monitor class message-1",UVM_HIGH);
    `uvm_info("mon1","monitor class message-2",UVM_HIGH);
  endtask
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  driver drv;
  monitor mon;
  function new(string n="env",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    drv=new("drv",this);
    mon=new("mon",this);
    drv.run;
    mon.run;
  endtask
endclass

module test;
  env e;
  initial
    begin
      e=new("e",null);
      e.set_report_verbosity_level_hier(UVM_HIGH);  //now the verbosity of all the hier of the class env is UVM_HIGH
      e.run;
    end
endmodule
