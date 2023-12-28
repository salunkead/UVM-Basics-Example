//The uvm_event_pool class
/*
1. uvm_event_pool plays crucial role in synchronizing concurrent processes within your testbench.
2. it acts as central repository for shared uvm_event objects,allowing different components to efficiently access them (in short,it is used to share uvm_event handle between different components)
3. Methods used are as follows:-
  1. static function T get_global (KEY  key) -> Returns the specified item instance from the global item pool.
  2. virtual function void trigger (uvm_object data = null) -> Triggers the event, resuming all waiting processes.
  3. virtual task wait_trigger () -> Waits for the event to be triggered.
*/

//Example: synchronizing run_phase of comp1 and comp2 using uvm_event_pool
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  uvm_event ev1;
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
    ev1=uvm_event_pool::get_global("key");  //the key of comp1 and comp2 must be same
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #5;
    $display("[Comp1], ","run_phase executes at t=%0t",$time);
    ev1.trigger();
    phase.drop_objection(this);
  endtask
endclass

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  uvm_event ev2;
  function new(string n="comp2",uvm_component p=null);
    super.new(n,p);
    ev2=uvm_event_pool::get_global("key");
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ev2.wait_trigger();
    $display("[Comp2], ","run_phase executes at t=%0t",$time);
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
