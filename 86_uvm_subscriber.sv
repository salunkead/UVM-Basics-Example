// uvm_subscriber class
/*
1.class declaration:-
  virtual class uvm_subscriber #(
    	type  	T 	 =  	int
) extends uvm_component

2.ports:-
 analysis_export

3.Methods:-
 1. function new ( 	string  	name,uvm_component  	parent 	)
 2. pure virtual function void write( 	T  	t 	)

4.subscribers are often used to collect functional coverage by sampling covergroups based on received transactions.
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class seq_item extends uvm_object;
  `uvm_object_utils(seq_item)
  function new(string n="seq_item");
    super.new(n);
  endfunction
  rand bit[7:0]data;
endclass

class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  seq_item item;
  uvm_analysis_port #(seq_item) port;
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
    port=new("port",this);
  endfunction
  function void build_phase(uvm_phase phase);
    item=seq_item::type_id::create("item");
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(10)
      begin
        item.randomize;
        `uvm_info(get_type_name,$sformatf("data sent from comp1 is : %0d",item.data),UVM_NONE);
        port.write(item);
        #10;
      end
    phase.drop_objection(this);
  endtask  
endclass

class subscriber extends uvm_subscriber  #(seq_item);
  `uvm_component_utils(subscriber)
  function new(string n="sub",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void write(seq_item t);
    `uvm_info(get_type_name,$sformatf("data received from comp1 is : %0d",t.data),UVM_NONE);
  endfunction
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="container",uvm_component p=null);
    super.new(n,p);
  endfunction
  comp1 c1;
  subscriber sub;
  function void build_phase(uvm_phase phase);
    c1=comp1::type_id::create("c1",this);
    sub=subscriber::type_id::create("sub",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    c1.port.connect(sub.analysis_export);
  endfunction
endclass

module top;
  initial run_test("container");
endmodule
