//Changing the severity of the reporting macros
/*
1.some commonly used UVM reporting macros and their severity levels
  1.`uvm_info:-
     1.used for informative messages
     2.syntax:- `uvm_info("id","msg",redundancy level)
     3.severity levels:
      `UVM_INFO:standard information
      `UVM_MEDIUM:medium importance information
      `UVM_FULL:high importance information
  2. `uvm_warning:-
     1.used for warning messages
     2.syntax:-`uvm_warning("id","warning msg");
     3.severity level:-`UVM_WARNING
  3.`uvm_error:-
     1.used for error messages
     2.syntax:-`uvm_error("id","error msg");
     3.severity level:-`UVM_ERROR
  4.`uvm_fatal:-
     1.used for fatal error messages that leads to termination of simulation
     2.syntax:-`uvm_fatal("id","fatal msg");
     3.severity level- `UVM_FATAL
*/

//Code-1 without changing severity
`include "uvm_macros.svh"
import uvm_pkg::*;
class report extends uvm_component;
  `uvm_component_utils(report)
  function new(string n="report",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run();
    `uvm_info("report","infomative message",UVM_MEDIUM);
    `uvm_error("report","Error..!");
    #5;
    `uvm_fatal("report","Fatal error:simulation terminates"); //terminates the simulation at t=5 time unit
  endtask
endclass

module test;
  report r;
  initial
    begin
      r=new("r",null);
      r.run();
    end
endmodule

//code-2 changing severity of uvm_fatal to uvm_error
//set_report_severity_override(uvm_severity cur_severity,uvm_severity new_severity) this method can be used to change the severity
`include "uvm_macros.svh"
import uvm_pkg::*;
class report extends uvm_component;
  `uvm_component_utils(report)
  function new(string n="report",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run();
    `uvm_info("report","infomative message",UVM_MEDIUM);
    `uvm_error("report","Error..!");
    #5;
    `uvm_fatal("report","Fatal error:simulation terminates");
  endtask
endclass

module test;
  report r;
  initial
    begin
      r=new("r",null);
      r.set_report_severity_override(UVM_ERROR,UVM_INFO);   //all the `uvm_error will behave as `uvm_info
      r.set_report_severity_override(UVM_FATAL,UVM_ERROR);  //simulation will not terminate now,as we have changed the severity of `uvm_fatal
      r.run();
    end
endmodule

