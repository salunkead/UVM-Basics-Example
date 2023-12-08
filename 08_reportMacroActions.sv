//Reporting macro actions
/*
1.report actions are as follows:-
  1.UVM_NO_ACTION- no action is taken
  2.UVM_DISPLAY- sends the report to the standard output
  3.UVM_LOG- sends the report to the file for this (severity/id) pair
  3.UVM_COUNT- count the number of report with count attribute.when this value reaches max_count,the simulation terminates
  4.UVM_EXIT- terminates the simulation 
  5.UVM_STOP- stops the simulation(calls $stop system task)
  ------------------------------------------------------------
  enum type defined in uvm_object_globals.svh file
  typedef enum
  {
  UVM_NO_ACTION = 'b000000,
  UVM_DISPLAY   = 'b000001,
  UVM_LOG       = 'b000010,
  UVM_COUNT     = 'b000100,
  UVM_EXIT      = 'b001000,
  UVM_CALL_HOOK = 'b010000,
  UVM_STOP      = 'b100000
  } uvm_action_type;
  
*/

//code-1:-> Get report action by id
//function int get_report_action(uvm_severity severity,string id)-> gets the action assiciated with given id
//above function is defined in uvm_report_object class

`include "uvm_macros.svh"
import uvm_pkg::*;
class action extends uvm_component;
  `uvm_component_utils(action)
  function new(string n="act",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id1","class action msg",UVM_NONE);
  endtask
endclass

module test;
  action act;
  initial
    begin
      act=new("act",null);
      $display("report action is %0b",act.get_report_action(UVM_INFO,"id1")); //this statement displays 1 means UVM_DISPLAY is the default action
      act.run;
    end
endmodule

//code-2 the use of function: function void set_report_severity_action (uvm_severity severity,uvm_action action)
`include "uvm_macros.svh"
import uvm_pkg::*;
class action extends uvm_component;
  `uvm_component_utils(action)
  function new(string n="act",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id-1","class action info msg with id-1",UVM_NONE); //uvm_info will not be displayed on console as the action of this severity changed to UVM_NO_ACTION
    `uvm_info("id-2","class action info msg with id-2",UVM_NONE);
    `uvm_error("id-3","class action error msg");
  endtask
endclass

module test;
  action act;
  initial
    begin
      act=new("act",null);
      act.set_report_severity_action (UVM_INFO,UVM_NO_ACTION); //all the uvm_info of the class action will not be displayed on console
      act.run;
    end
endmodule

//code-3 the use of function: function void set_report_id_action (string id,uvm_action action)
`include "uvm_macros.svh"
import uvm_pkg::*;
class action extends uvm_component;
  `uvm_component_utils(action)
  function new(string n="act",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id-1","class action info msg with id-1",UVM_NONE);
    `uvm_info("id-2","class action info msg with id-2",UVM_NONE);
    `uvm_error("id-3","class action error msg"); //this msg will not printed on console as the action is changed to UVM_NO_ACTION
  endtask
endclass

module test;
  action act;
  initial
    begin
      act=new("act",null);
      act.set_report_id_action ("id-3",UVM_NO_ACTION);  //error message will not printed on console
      act.run;
    end
endmodule

//code-4 the use of function-> function void set_report_severity_id_action (uvm_severity severity,string id,uvm_action action)
`include "uvm_macros.svh"
import uvm_pkg::*;
class action extends uvm_component;
  `uvm_component_utils(action)
  function new(string n="act",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id-1","class action info msg with id-1",UVM_NONE);
    `uvm_info("id-2","class action info msg with id-2",UVM_NONE); //this msg will not displayed on console
    `uvm_error("id-3","class action error msg"); //as the simulation is terminated due to action changed of the above id,this msg is also not displayed on console
  endtask
endclass

module test;
  action act;
  initial
    begin
      act=new("act",null);
      act.set_report_severity_id_action (UVM_INFO,"id-2",UVM_EXIT);  //the message with id-2 will not be displayed and terminates simulation
      act.run;
    end
endmodule
