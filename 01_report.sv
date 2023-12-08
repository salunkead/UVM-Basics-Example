//Reporting macros in UVM-`uvm_info()
/*
1.reporting macros are a set of predefined macros used to generate messages and reports during simulation.
2.these macros simplify the process of displaying information,warnings and errors.
  syntax:- `uvm_info(id,message,redundancy_level);
  id->this specifically used to tell which class is sending data (path name of the class sending data to a console)
  message-> message to be sent on the terminal
  redundany level->it allows to control the amount of detail reported during simulation
            default redundancy level is UVM_MEDIUM=200,if redundancy level specified in uvm info is greater than default redundancy level then message will not displayed on console
 available redundancy levels
   UVM_NONE=0
   UVM_LOW=100
   UVM_MEDIUM=200 //default redundancy level
   UVM_HIGH=300
   UVM_FULL=400
   UVM_DEBUG=500
3.if we donot change the redundancy level then the `uvm_info() with redundancy level UVM_HIGH,UVM_FULL,UVM_DEBUG will not be displayed on console
4.to get any message displayed over console the redundancy level should be less than or equal to default redundancy level.set redundancy level<=default redundancy level
5.`uvm_info() macros is used to generate informational message during simulation
*/

//Example-1

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
    `uvm_info("report","Message:verbosity level-UVM_HIGH",UVM_HIGH); //UVM_HIGH(300)>default redundancy level UVM_MEDIUM(200) -> msg will not be displayed on console
    `uvm_info("report","Message:verbosity level-UVM_FULL",UVM_FULL);  //UVM_FULL(400)>default redundancy level UVM_MEDIUM(200) -> msg will not be displayed on console
    `uvm_info("report","Message:verobosity level-UVM_DEBUG",UVM_DEBUG); //UVM_DEBUG(500)>default redundancy level UVM_MEDIUM(200) -> msg will not be displayed on console
  endtask
endclass

module test;
  Report r;
  initial
    begin
      r=new("r",null);
      $display("this method is used to get verbosity level: %0d",r.get_report_verbosity_level()); //as we have not changed verosity level,the default verbosity level is UVM_DEFAULT(200)
      r.run;                                                                                      //all the messages with verbosity level greater than default verbosity level will not be displayed on console
    end
endmodule
