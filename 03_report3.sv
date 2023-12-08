//Changing the verbosity level of the specific id
/*
1.we can change the verobosity level of the specific id by using method set_report_id_verbosity (string id,int verbosity) defined in uvm_report_object class
*/

//code-1 verbosity level is 200(UVM_MEDIUM)

`include "uvm_macros.svh"
import uvm_pkg::*;
class report extends uvm_component;
  `uvm_component_utils(report)
  function new(string n="report",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run();
    `uvm_info("id1","message-1",UVM_HIGH); //these two messages will not displayed on console
    `uvm_info("id2","message-2",UVM_HIGH);
  endtask
endclass

module test;
  report r;
  initial
    begin
      r=new("r",null);
      $display("verbosity level is: %0d",r.get_report_verbosity_level());
    end
endmodule

//code-2 changing the verbosity level of message id(id1)

`include "uvm_macros.svh"
import uvm_pkg::*;
class report extends uvm_component;
  `uvm_component_utils(report)
  function new(string n="report",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run();
    `uvm_info("id1","message-1",UVM_HIGH); //only this message will be displayed on console
    `uvm_info("id2","message-2",UVM_HIGH);
  endtask
endclass

module test;
  report r;
  initial
    begin
      r=new("r",null);
      $display("verbosity level is: %0d",r.get_report_verbosity_level());
      r.set_report_id_verbosity ("id1",300); 
      r.run();
    end
endmodule
