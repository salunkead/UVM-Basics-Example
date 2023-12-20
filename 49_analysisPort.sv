//TLM Analysis port
/*
1.TLM analysis ports provide a powerful and efficient mechanism for broadcasting data to multiple components in UVM.
2.One to many communication:-
  A single analysis port can broadcast data to many number of subscribers
3.the source component generates the data to be shared and writes the data to it's anaysis port using the write function/method
4.syntax:- 
  1. uvm_analysis_port #(type T) port_name
       T is the type of data that port will transmit
  2. uvm_analysis_imp #(type T,IMP) imp_name;
      T- is the type of data to received
      IMP- the type of component which implements the interface
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  uvm_analysis_port #(int)port;
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
    port=new("port",this);
  endfunction
  int a;
  task main_phase(uvm_phase phase);
    repeat(10)
      begin
        a=$urandom_range(1,100);
        $display("[comp1] ","data sent: a=%0d",a);
        port.write(a);
      end
  endtask
endclass

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  uvm_analysis_imp #(int,comp2) imp;
  function new(string n="comp2",uvm_component p=null);
    super.new(n,p);
    imp=new("imp",this);
  endfunction
  function void write(int a);
    $display("[comp2] ","data received: a=%0d",a);
  endfunction
  
endclass

class comp3 extends uvm_component;
  `uvm_component_utils(comp3)
  uvm_analysis_imp #(int,comp3) imp;
  function new(string n="comp3",uvm_component p=null);
    super.new(n,p);
    imp=new("imp",this);
  endfunction
  function void write(int a);
    $display("[comp3] ","data received: a=%0d",a);
  endfunction
endclass

class comp4 extends uvm_component;
  `uvm_component_utils(comp4)
  uvm_analysis_imp #(int,comp4) imp;
  function new(string n="comp4",uvm_component p=null);
    super.new(n,p);
    imp=new("imp",this);
  endfunction
  function void write(int a);
    $display("[comp4] ","data received: a=%0d",a);
    $display("---------------------------------------");
  endfunction
  
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="con",uvm_component p=null);
    super.new(n,p);
  endfunction
  comp1 c1;
  comp2 c2;
  comp3 c3;
  comp4 c4;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1=comp1::type_id::create("c1",this);
    c2=comp2::type_id::create("c2",this);
    c3=comp3::type_id::create("c3",this);
    c4=comp4::type_id::create("c4",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    c1.port.connect(c2.imp);
    c1.port.connect(c3.imp);
    c1.port.connect(c4.imp);
  endfunction
endclass

module top;
  initial run_test("container");
endmodule
