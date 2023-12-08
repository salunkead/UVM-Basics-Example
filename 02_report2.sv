//Reporting macros - changing the verbosity level
/*
1.to get versosity level,we can use method get_report_verbosity_level(),the return type of the method is integer
2.to change the verbosity level of the message,we can use the method set_report_verbosity_level(int verbosity_level) defined in uvm_report_object class
*/

`include "uvm_macros.svh"
import uvm_pkg::*;
class Report extends uvm_component;
  `uvm_component_utils(Report)
  function new(string name="Report",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  task run();
    `uvm_info("report","Message:verbosity level-UVM_NONE",UVM_NONE);
    `uvm_info("report","Message:verbosity level-UVM_LOW",UVM_LOW);
    `uvm_info("report","Message:verbosiy level-UVM_MEDIUM",UVM_MEDIUM);
    `uvm_info("report","Message:verbosity level-UVM_HIGH",UVM_HIGH);
    `uvm_info("report","Message:verbosity level-UVM_FULL",UVM_FULL);
    `uvm_info("report","Message:verobosity level-UVM_DEBUG",UVM_DEBUG);//500 (UVM_DEBUG) > set verbosity level 400 (UVM_FULL),wll not be displayed on console
  endtask
endclass

module test;
  Report r;
  initial
    begin
      r=new("r",null);
      $display("default verbosity was : %0d",r.get_report_verbosity_level());
      r.set_report_verbosity_level(400);
      $display("changed verbosity level is : %0d",r.get_report_verbosity_level());
      r.run;  //all the messages with verobosity level<=400(UVM_FULL) will get displayed over console
    end
endmodule
