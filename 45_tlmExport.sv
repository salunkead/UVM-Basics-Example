// Port -> export -> imp
/*
1.an export is the special type of TLM port attached to a child component in hierarchy.
2.it's primary function is to receive transaction coming trhough it's own TLM port and then forward them upwards to the parent component's export,if one exists
3.this allows transaction to propogate through hierarchy and reach various components that might need to access them
4.types of exports
  1.uvm_*_export #(T) -> unidirectional export for forwarding transactions in one direction,T-type of data to be communicated
  2.uvm_*_export #(REQ,RSP) -> bidirectional export for forwarding both request and response transactions
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class child extends uvm_component;
  `uvm_component_utils(child)
  uvm_blocking_put_port #(int) port;
  function new(string n="child",uvm_component p=null);
    super.new(n,p);
    port=new("c1",this);
  endfunction
  int num=144;
  task main_phase(uvm_phase phase);
    port.put(num);
    $display("data sent from child to main parent is : %0d",num);
  endtask
endclass

class parent extends uvm_component;
  `uvm_component_utils(parent)
  uvm_blocking_put_export #(int)exp;
  function new(string n="parent",uvm_component p=null);
    super.new(n,p);
    exp=new("exp",this);  //it's job is to forward the data to upwards
  endfunction
  child c;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c=child::type_id::create("c",this);
  endfunction
endclass

class main_parent extends uvm_component;
  `uvm_component_utils(main_parent)
  uvm_blocking_put_imp #(int,main_parent) imp;
  function new(string n="child",uvm_component p=null);
    super.new(n,p);
    imp=new("imp",this);
  endfunction
  parent p;
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     p=parent::type_id::create("p",this);
  endfunction
  task put(int data);
    $display("data received from child is: %0d",data);
  endtask
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="cont",uvm_component p=null);
    super.new(n,p);
  endfunction
  main_parent mp;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mp=main_parent::type_id::create("mp",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mp.p.c.port.connect(mp.p.exp);
    mp.p.exp.connect(mp.imp);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology(uvm_default_tree_printer);
  endfunction
endclass

module top;
  initial run_test("container");
endmodule
