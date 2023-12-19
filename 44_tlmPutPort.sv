//uvm_blocking_put_port and uvm_blocking_put_imp 

/*
1.the TLM port is used to send the transaction
2.the tlm port has unidirectional and bidirectional ports
3.a port can be connected to any compatible port,export,imp
  Allowed connections are as follows,
    1.port-to-imp
    2.port-to-port
    3.port-to-export
    4.export-to-export
    5.export-to-imp
4.TLM port class  
  uvm_*_port #(T)          //unidirectional port class
  T- is the type of data to be communicated
5.function new (string name,uvm_component parent,int min_size=1,int max_size=1); -> used to create TLM port
------------------------------------------------------------------------------------------------------
TLM imp port
1.it is used to receive transaction at the destination
2.TLM imp port has unidirectional and bidirection ports
3.uvm_*_imp #(T,IMP)                 //unidirectional Imp port class
  T - type of data to be communicated 
  IMP - type of the component implementing the interface
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class producer extends uvm_component;
  `uvm_component_utils(producer)
  uvm_blocking_put_port #(int) port;
  int num;
  function new(string n="prod",uvm_component p=null);
    super.new(n,p);
    port=new("port",this);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(10)
      begin
        std::randomize(num) with {num>=10 && num<=50;};
        `uvm_info("comp1",$sformatf("data sent: num=%0d",num),UVM_NONE)
        port.put(num);
        #12;
      end
    phase.drop_objection(this);
  endtask
endclass

class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  uvm_blocking_put_imp#(int,consumer) imp;
  function new(string n="cons",uvm_component p=null);
    super.new(n,p);
    imp=new("imp",this);
  endfunction
  task put(int data);
    `uvm_info("comp2",$sformatf("data sent: DATA=%0d",data),UVM_NONE);
    $display("-------------------------------------------------------------------------");
  endtask
endclass
class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="const",uvm_component p=null);
    super.new(n,p);
  endfunction
  producer c1;
  consumer c2;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1=producer::type_id::create("c1",this);
    c2=consumer::type_id::create("c2",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    c1.port.connect(c2.imp);
  endfunction
endclass

module test;
  initial run_test("container");
endmodule
