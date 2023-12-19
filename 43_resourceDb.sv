//uvm_resource_db class

/*
1.methods used are as below
  1.static function void set(input string scope,input string name,T val,input uvm_object accessor=null) -> Create a new resource, write a val to it, and set it into the database using name and scope as the lookup parameters. 
  2.static function bit read_by_name(input string scope,input string name,inout T val,input uvm_object accessor=null)  
    ->locate a resource by name and scope and read its value.  The value is returned through the output argument val.  The return value is a bit that indicates whether or not the read was successful.
2.uvm_config_db:-
  1.stores values in a key and value pair format
  2.keys are hierarchical strings representing the scope within the uvm_component tree
  3.values can be scalar types,class handles,queue,virtual interface etc
3.uvm_resource_db:-
  1.stores resources in a named object pool
  2.resources are identified by unique names,independent of component hierarchy
  3.resources can be any uvm object type including scoreboard,monitor etc
4.uvm_config_db-> it uses a hierarchical key-value pair strutcure
  
  scope                |       key
  ----------------------------------------------
  top                  |  clock_freq
  top.env              |  memory_init
  top.env.test.case1   | test_parameter

5.uvm_resource_db-> it manages resources by names
       name            |   type
-----------------------------------------------------
    scoreboard         |  uvm_scoreboard
    monitor            |  uvm_monitor
*/


//Example
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp extends uvm_component;
  `uvm_component_utils(comp)
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
  endfunction
  real a;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_resource_db#(real)::read_by_name(get_full_name,"a",a);
    $display("value of a: %0.4f",a);
  endfunction
endclass

module top;
  initial
    begin
      uvm_resource_db#(real)::set("uvm_test_top","a",12.41);
      run_test("comp");
    end
endmodule
