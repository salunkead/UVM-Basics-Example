//Non-blocking transport port and imp port

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  uvm_nonblocking_transport_port #(int,real) port;
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
    port=new("port",this);
  endfunction
  int sdata=128;
  real rdata;
  task main_phase(uvm_phase phase);
    port.nb_transport(sdata,rdata);
    $display("[comp1] ","data sent from comp1 is : %0d",sdata);
    $display("[comp1] ","data received from comp2 is %0.2f",rdata);
  endtask
endclass

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  uvm_nonblocking_transport_imp #(int,real,comp2) imp;
  function new(string n="comp2",uvm_component p=null);
    super.new(n,p);
    imp=new("imp",this);
  endfunction
  function bit nb_transport(input int rdata,output real sdata);
    sdata=12.56;
    $display("[comp2] ","data received from comp1 is : %0d",rdata);
    $display("[comp2] ","data sent from comp2 is : %0.2f",sdata);
  endfunction
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="cont",uvm_component p=null);
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

module test;
  initial run_test("container");
endmodule
