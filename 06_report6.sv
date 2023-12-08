//Changing verbosity when there are more than one component
/*
1.object.set_report_verbosity_level(verbosity_level_to_be_set); can be used to change the verbosity level
*/

//code-1 before changing verbosity level
//as the default verbosity level set by simulator is 200(UVM_MEDIUM)
//no message will be displayed on console
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

module test;
  driver drv;
  monitor mon;
  initial
    begin
      drv=new("drv",null);
      mon=new("mon",null);
      //before changing verbosity
      $display("current vebosity level of driver class is %0d",drv.get_report_verbosity_level());
      $display("current vebosity level of monitor class is %0d",mon.get_report_verbosity_level());
      drv.run;
      mon.run;
    end
endmodule

//code-2
//changing verbosity of driver class
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

module test;
  driver drv;
  monitor mon;
  initial
    begin
      drv=new("drv",null);
      mon=new("mon",null);
      //after changing verbosity level of driver class
      drv.set_report_verbosity_level(UVM_HIGH); //WE CAN PASS UVM_HIGH OR 300 AS ACTUAL ARGUMENT
      $display("current vebosity level of driver class is %0d",drv.get_report_verbosity_level());
      $display("current vebosity level of monitor class is %0d",mon.get_report_verbosity_level());
      drv.run;
      mon.run;
    end
endmodule
