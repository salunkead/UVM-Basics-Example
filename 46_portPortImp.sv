//Connecting port to port to imp
`include "uvm_macros.svh"
import uvm_pkg::*;

class sub_producer extends uvm_component;
  `uvm_component_utils(sub_producer)
  uvm_blocking_put_port #(real) port1;
  function new(string n="sprod",uvm_component p=null);
    super.new(n,p);
    port1=new("port1",this);
  endfunction
  real num=12.25;
  task run_phase(uvm_phase phase);
    $display("data sent from sub-producer: %0.2f",num);
    port1.put(num);
  endtask
endclass

class producer extends uvm_component;
   `uvm_component_utils(producer)
  uvm_blocking_put_port #(real) port2;
  function new(string n="prod",uvm_component p=null);
    super.new(n,p);
    port2=new("port2",this);
  endfunction
  sub_producer sprod;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sprod=sub_producer::type_id::create("sprod",this);
  endfunction
endclass

class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  uvm_blocking_put_imp #(real,consumer) imp;
  function new(string n="sprod",uvm_component p=null);
    super.new(n,p);
    imp=new("imp",this);
  endfunction
  producer prod;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    prod= producer::type_id::create("prod",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    prod.sprod.port1.connect(prod.port2);
    prod.port2.connect(imp);
  endfunction
  task put(real rdata);
    $display("data received from sub-producer: %0.2f",rdata);
  endtask
endclass

module test;
  initial run_test("consumer");
endmodule
