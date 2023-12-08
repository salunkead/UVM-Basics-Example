//Changing the severity of the macro by id
/*
1.severity of any macros can also be changed by id
2.function void set_report_severity_id_override(uvm_severity cur_severity,string id,uvm_severity new_severity),this method is used to change the severity by id
*/

//code-1 before changing severity
`include "uvm_macros.svh"
import uvm_pkg::*;
class report extends uvm_component;
  `uvm_component_utils(report)
  function new(string n="report",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run();
    `uvm_info("id1","infomative message",UVM_MEDIUM);
    `uvm_error("id2","Error-1..!");
    #1;
    `uvm_error("id3","Error-2..!");
    #5;
    `uvm_fatal("report","Fatal error:simulation terminates");
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

//code-2 after changing the severity of message with id id2
`include "uvm_macros.svh"
import uvm_pkg::*;
class report extends uvm_component;
  `uvm_component_utils(report)
  function new(string n="report",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run();
    `uvm_info("id1","infomative message",UVM_MEDIUM);
    `uvm_error("id2","Error-1..!");
    #1;
    `uvm_error("id3","Error-2..!");
    #5;
    `uvm_fatal("report","Fatal error:simulation terminates");
  endtask
endclass

module test;
  report r;
  initial
    begin
      r=new("r",null);
      r.set_report_severity_id_override(UVM_ERROR,"id2",UVM_INFO);
      r.run();
    end
endmodule
