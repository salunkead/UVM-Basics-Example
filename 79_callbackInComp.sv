//Implementaion of callback in uvm_component class
/*
1.callbacks enable you to introduce additional driving logic or customization without directly modifying the core components of the verification environment.
  example:-if you need to implement specific error injection mechanism during run_phase of driver,you could define custom callback triggered at the appropriate point within driver's run_phase task
           this would allow you to inject errors without modifying the driver's core logic
2.macros used:-
  1. `uvm_register_cb(T,CB) -> Registers the given CB callback type with the given T object type
  2. `uvm_do_callbacks(T,CB,METHOD)
    -> T - object type associated with the callback
    -> CB - callback class type
    -> METHOD - callback method to call
3.Class and Method
   -> class declaration
   class uvm_callbacks #(type  	T 	 =  	uvm_object,type  	CB 	 =  	uvm_callback) extends uvm_typed_callbacks #(T)
   -> Method used
   static function void add(
    	T  	obj, 	   	
    	uvm_callback  	cb, 	   	
    	uvm_apprepend  	ordering 	 =  	UVM_APPEND
    )
    -> Registers the given callback object, cb, with the given obj handle.
*/

//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class callback extends uvm_callback;
  `uvm_object_utils(callback)
  function new(string n="call");
    super.new(n);
  endfunction
  function void Method1();
    $display("[Callback], ","Callback Method 1..!");
  endfunction
  task Method2();
    $display("[Callback], ","Callback Method 2...!");
  endtask
endclass

class comp extends uvm_component;
  `uvm_component_utils(comp)
  `uvm_register_cb(comp,callback)   //register callback type class with the comp type class
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
  endfunction
  callback call;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    call=callback::type_id::create("call");
    uvm_callbacks#(comp,callback)::add(this,call); //in add method..first argument is object of the class where we want to call callback method,second one is the object of callback class
  endfunction
  task run_phase(uvm_phase phase);
    $display("[Comp], ","Calling callback Method1");
    `uvm_do_callbacks(comp,callback,Method1)   //class where callback is registered,callback class,method to call from callback class
    $display("[Comp], ","Calling callback Method 2");
    `uvm_do_callbacks(comp,callback,Method2) 
  endtask
endclass

module test;
  initial run_test("comp");
endmodule
