//Get port and imp
/*
1.get port is used in communication between components within testbench to retrieve transaction from another component.
2.it is opposite of put port,which sends transactions.
3.the data flow direction in case of get port and put put are opposite to each other
4.declaring a get port:-
  uvm_<blocking or nonblcoking>_get_port #(type T) port_name;
  T- is the type of transaction port will handle
5.declaring the get imp:-
  uvm_<blocking or nonblocking>_get_imp #(type T,IMP) port_name;
   T- is the type of transaction the port will handle
   IMP- type of component that implements the get interface
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class producer extends uvm_component;
  `uvm_component_utils(producer)
  uvm_blocking_get_port #(int) port;
  int num;
  function new(string n="prod",uvm_component p=null);
    super.new(n,p);
    port=new("port",this);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(10)
      begin
        port.get(num);
        $display("producer :-> ","data received from consumer: num=%0d",num);
        $display("---------------------------------------------------------------");
      end
    phase.drop_objection(this);
  endtask
endclass

class consumer extends uvm_component;
  `uvm_component_utils(consumer)
  uvm_blocking_get_imp#(int,consumer) imp;
  int a;
  function new(string n="cons",uvm_component p=null);
    super.new(n,p);
    imp=new("imp",this);
  endfunction
  task get(output int data);
    a=$urandom_range(1,100);
    data=a;
    $display("consumer :-> ","data sent from consumer: a=%0d",data);
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
