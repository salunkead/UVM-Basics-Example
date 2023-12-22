// The uvm_component_registry#(T,Tname) class
/*
1.class uvm_component_registry #(type  	T 	 =  	uvm_component,string  	Tname 	 =  	"<unknown>") extends uvm_object_wrapper
    1.the above class allows the UVM factory to create and configure components dynamically at run-time ,without requiring an instance of the component itself.
    2.this class is used to register UVM component type class with factory
2.methods used :-
  1.virtual function string get_type_name() -> Returns the value given by the string parameter, Tname.
  2.static function this_type get() -> the get method returns the singleton object of the registry class.
*/

//factroy registeration without using `uvm_component_utils macro
`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_component;
  typedef uvm_component_registry#(driver,"driver") type_id;
  static function type_id get_type();
    return type_id::get();
  endfunction
  function string get_type_name();
    return "driver";
  endfunction
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("Running build phase of the component");
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("Running connect phase of the component");
  endfunction
endclass

module test;
  initial run_test("driver");
endmodule
