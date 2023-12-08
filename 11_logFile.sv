//Working on log file
/*
1. predefined function to be used for log file
  1. function void set_report_default_file(UVM_FILE file) :used to write the content to the file
  2. function void set_report_severity_file (uvm_severity severity,UVM_FILE file) :only the specified severity will be written inside file
  3. function void set_report_id_file (string id,UVM_FILE file) :only the specified id will be written inside the file
  4. function void set_report_severity_id_file (uvm_severity severity,string id,UVM_FILE file) :severity with given id will be written inside file
2.we need to change the action of the uvm macro
  1. to write any message into the specified file,we need to change the action as UVM_LOG
*/

//Example
//Code-1 use of function set_report_default_file
`include "uvm_macros.svh"
import uvm_pkg::*;
class logFile extends uvm_component;
  `uvm_component_utils(logFile)
  function new(string n="f",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id-1","Informative message to be displayed in file report.txt",UVM_NONE);
    `uvm_error("id-3","Error message to be displayed in file report.txt");
    #1;
    `uvm_fatal("id-5","UVM FATAL: message to be displayed in file report.txt");
  endtask
endclass

module test;
  logFile f;
  UVM_FILE fd; //or int fd; both work
  initial
    begin
      f=new("f",null);
      fd=$fopen("report.txt","w");
      f.set_report_default_file (fd);
      f.set_report_severity_action (UVM_INFO,UVM_DISPLAY|UVM_LOG); //here we are telling compiler to write and display on console all the messages associated with severity UVM_INFO
      f.set_report_severity_action(UVM_ERROR,UVM_DISPLAY|UVM_LOG);
      f.set_report_severity_action(UVM_FATAL,UVM_DISPLAY|UVM_LOG);
      f.run;
      $fclose(fd);
    end
endmodule

//Code-2 use of function set_report_severity_file
`include "uvm_macros.svh"
import uvm_pkg::*;
class logFile extends uvm_component;
  `uvm_component_utils(logFile)
  function new(string n="f",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id-1","Informative message to be displayed in file report.txt",UVM_NONE);
    `uvm_error("id-3","Error message to be displayed in file report.txt");
    #1;
    `uvm_fatal("id-5","UVM FATAL: message to be displayed in file report.txt");
  endtask
endclass

module test;
  logFile f;
  UVM_FILE fd;
  initial
    begin
      f=new("f",null);
      fd=$fopen("report.txt","w");
      f.set_report_severity_file (UVM_INFO,fd);
      f.set_report_severity_action(UVM_INFO,UVM_DISPLAY|UVM_LOG);
      f.run;
      $fclose(fd);
    end
endmodule

//Code-3 use of function void set_report_id_file (string id,UVM_FILE file)
`include "uvm_macros.svh"
import uvm_pkg::*;
class logFile extends uvm_component;
  `uvm_component_utils(logFile)
  function new(string n="f",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id-1","Informative message to be displayed in file report.txt",UVM_NONE);
    `uvm_error("id-3","Error message to be displayed in file report.txt");
    #1;
    `uvm_fatal("id-5","UVM FATAL: message to be displayed in file report.txt");
  endtask
endclass

module test;
  logFile f;
  UVM_FILE fd;
  initial
    begin
      f=new("f",null);
      fd=$fopen("report.txt","w");
      f.set_report_id_file ("id-3",fd);
      f.set_report_id_action("id-3",UVM_DISPLAY|UVM_LOG);
      f.run;
      $fclose(fd);
    end
endmodule

//Code-4 use of function void set_report_severity_id_file (uvm_severity severity,string id,UVM_FILE file)
`include "uvm_macros.svh"
import uvm_pkg::*;
class logFile extends uvm_component;
  `uvm_component_utils(logFile)
  function new(string n="f",uvm_component p=null);
    super.new(n,p);
  endfunction
  task run;
    `uvm_info("id-1","Informative message-1 to be displayed in file report.txt",UVM_NONE);
    `uvm_info("id-2","Informative message-2 to be displayed in file report.txt",UVM_NONE);
    `uvm_error("id-3","Error message to be displayed in file report.txt");
    #1;
    `uvm_fatal("id-5","UVM FATAL: message to be displayed in file report.txt");
  endtask
endclass

module test;
  logFile f;
  UVM_FILE fd;
  initial
    begin
      f=new("qt",null);
      fd=$fopen("report.txt","w");
      f.set_report_severity_id_file (UVM_INFO,"id-2",fd);
      f.set_report_severity_id_action(UVM_INFO,"id-2",UVM_DISPLAY|UVM_LOG);
      f.run;
      $fclose(fd);
    end
endmodule
