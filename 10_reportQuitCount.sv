//The method set_report_max_quit_count
/*
1. function void set_report_max_quit_count(int max_count);
2. when the error in the simulation reaches max_count then die method gets called which leads to termination of the simulation
*/

//code-1 when the count is 2 and error message is 1
`include "uvm_macros.svh"
import uvm_pkg::*;
class quit extends uvm_component;
  `uvm_component_utils(quit)
  function new(string n="qt",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id-1","class quit info msg with id-1",UVM_NONE);
    `uvm_info("id-2","class quit info msg with id-2",UVM_NONE);
    `uvm_error("id-3","class quit error msg");  //as there is only one error message and max_count is 2 therefore NO TERMINATION OF THE SIMULATION
  endtask
endclass

module test;
  quit qt;
  initial
    begin
      qt=new("qt",null);
      qt.set_report_max_quit_count(2);
      qt.run;
    end
endmodule

//code-2 when the count is 2 and error message are 2
//Quit count reached and simulation terminates
`include "uvm_macros.svh"
import uvm_pkg::*;
class quit extends uvm_component;
  `uvm_component_utils(quit)
  function new(string n="qt",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id-1","class quit info msg with id-1",UVM_NONE);
    `uvm_info("id-2","class quit info msg with id-2",UVM_NONE);
    `uvm_error("id-3","class quit error msg-1");
    `uvm_error("id-4","class quit error msg-2");
    #1;
    `uvm_info("id-5","written to check simulation terminated or not",UVM_NONE); //this msg will not be displayed as error msg equals to max_count
  endtask
endclass

module test;
  quit qt;
  initial
    begin
      qt=new("qt",null);
      qt.set_report_max_quit_count(2);
      qt.run;
    end
endmodule
