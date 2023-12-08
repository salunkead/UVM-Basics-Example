//The use of bitwise or(|) operator in uvm actions
/*
1.bitwise or operator can be used to perform more than one action
*/

//code-1 two actions UVM_DISPLAY and UVM_EXIT
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
    `uvm_error("id-3","class action error msg");
  endtask
endclass

module test;
  action act;
  initial
    begin
      act=new("act",null);
      act.set_report_severity_id_action (UVM_INFO,"id-2",UVM_DISPLAY|UVM_EXIT);  //here two action performed,display the message and then terminate the simulation
      act.run;
    end
endmodule
