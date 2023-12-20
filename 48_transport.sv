//Transport port
/*
1.the transport interface is used for communication between components when you want to send a request transaction and receive a corresponding respose transaction in a single function call
2.it can handle different request and response transaction types.
3.syntax:-
  uvm_<blocking or nonblocking>_transport_port #(type_req,type_rsp) port_name;
  uvm_<blocking or nonblocking>_transport_imp #(type_req,type_rsp,IMP) name;
  IMP - type of component which is implementing the interface
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;

class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  int a=102;
  real b;
  uvm_blocking_transport_port#(int,real)port;
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    port=new("port",this);
  endfunction
  task main_phase(uvm_phase phase);
    port.transport(a,b);
    $display("[comp1] ","data sent: a=%0d",a);
    $display("[comp1] ","data received: b=%0f",b);
  endtask
endclass

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  uvm_blocking_transport_imp#(int,real,comp2)imp;
  function new(string n="comp2",uvm_component p=null);
    super.new(n,p);
  endfunction
  int a;
  real b=3.14;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    imp=new("imp",this);
  endfunction
  task transport(input int a,output real b);
    b=this.b;
    $display("[comp2] ","data sent: b=%0f",b);
    $display("[comp2] ","data received: a=%0d",a);
    $display("------------------------------------");
  endtask
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="con",uvm_component p=null);
    super.new(n,p);
  endfunction
  comp1 c1;
  comp2 c2;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1=comp1::type_id::create("c1",this);
    c2=comp2::type_id::create("c2",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    c1.port.connect(c2.imp);
  endfunction
endclass

module top;
  initial run_test("container");
endmodule
