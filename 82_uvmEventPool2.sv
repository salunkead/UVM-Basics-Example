// virtual function uvm_object get_trigger_data () method of uvm_event class
/*
1. virtual function void trigger (uvm_object  	data 	 =  	null) 
-> Triggers the event, resuming all waiting processes.
-> An optional data argument can be supplied with the enable to provide trigger-specific information.

2. virtual function uvm_object get_trigger_data () 
-> Gets the data, if any, provided by the last call to trigger.
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class trans extends uvm_sequence_item;
  `uvm_object_utils(trans)
  function new(string n="tr");
    super.new(n);
  endfunction
  rand bit[7:0] data;
endclass

class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
  endfunction
  trans tr;
  uvm_event ev;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr=trans::type_id::create("tr");
    ev=uvm_event_pool::get_global("key");
  endfunction 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(5)
      begin
        tr.randomize();
        $display("[Comp1], ","data: %0d",tr.data);
        ev.trigger(tr);
        #5;
      end
    phase.drop_objection(this);
  endtask
endclass

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  function new(string n="comp2",uvm_component p=null);
    super.new(n,p);
  endfunction
  trans tr;
  uvm_event ev;
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ev=uvm_event_pool::get_global("key");
    repeat(5)
      begin
        ev.wait_trigger();
        $cast(tr,ev.get_trigger_data ());
        $display("[comp2], ","data : %0d",tr.data);
      end
    phase.drop_objection(this);
  endtask
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="container",uvm_component p=null);
    super.new(n,p);
  endfunction
  comp1 c1;
  comp2 c2;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1=comp1::type_id::create("c1",this);
    c2=comp2::type_id::create("c2",this);
  endfunction
endclass

module top;
  initial run_test("container");
endmodule
