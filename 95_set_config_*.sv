/*
set_config:-
1. only some specific types can be used. -> int,string and uvm_object type
2.from OVM
3. set_config_int("agent.driver","enable_flag",1)
4. int val;
   get_config_int("enable_flag",val);
   
set_config_db
1. any type can be sent

Why uvm_config_db is better?
1. type safety:- you can configure virtual interface, objects enums etc
2. wildcarding:- you can use "*" to broadcast config to multiple components
3. trace ability:- use +UVM_CONFIG_DB_TRACE to debug config propagation
*/




`include "uvm_macros.svh"
import uvm_pkg::*;

class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  function new(string name="comp1",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  int a;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   get_config_int("a",a);
    `uvm_info(get_name(),$sformatf("the value of a is : %0d",a),UVM_LOW)
    
  endfunction
endclass

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  function new(string name="comp2",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  int a;
  comp1 c1;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1=comp1::type_id::create("c1",this);
     a=102;
    set_config_int("c1","a",a);
    
  endfunction
  
endclass

module top;
  initial
    begin
      run_test("comp2");
    end
endmodule
