//uvm_config_db class - used to share resources between components
/*
1.uvm_config_db is used for storing and retrieving configuration settings between different components,such as test parameters,environment variables etc.
2.class uvm_config_db#(type T=int) extends uvm_resource_db#(T)
3.methods in this class are as follows:-
  1.static function bit get(uvm_component cntxt,string inst_name,string field_name,inout T value) 
     -> Get the value for field_name in inst_name, using component cntxt as the starting search point
  2.static function void set(uvm_component cntxt,string inst_name,string field_name,T value)
     ->Create a new or update an existing configuration setting for field_name in inst_name from cntxt.
4. cntxt - null refers to UVM_ROOT,when we use null then every component can access the value.
*/

//Code-1 sharing simple data of type int,real,string between components
`include "uvm_macros.svh"
import uvm_pkg::*;
class comp1 extends uvm_component;
  `uvm_component_utils(comp1)
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
  endfunction
  int ic1;
  real rc1;
  string stc1;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(int)::get(this,"","key1",ic1);
    `uvm_info("comp1",$sformatf("value of integer: ic1=%0d",ic1),UVM_NONE);
    uvm_config_db #(real)::get(this,"","key1",rc1);
    `uvm_info("comp1",$sformatf("value of real: rc1=%0.2f",rc1),UVM_NONE);
    uvm_config_db #(string)::get(this,"","key1",stc1);
    `uvm_info("comp1",$sformatf("value of string: stc1=%0s",stc1),UVM_NONE);
  endfunction
endclass

class comp2 extends uvm_component;
  `uvm_component_utils(comp2)
  function new(string n="comp2",uvm_component p=null);
    super.new(n,p);
  endfunction
  int ic2;
  real rc2;
  string stc2;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(int)::get(this,"","key1",ic2);
    `uvm_info("comp2",$sformatf("value of integer: ic2=%0d",ic2),UVM_NONE);
    uvm_config_db #(real)::get(this,"","key1",rc2);
    `uvm_info("comp2",$sformatf("value of real: rc2=%0.2f",rc2),UVM_NONE);
    uvm_config_db #(string)::get(this,"","key1",stc2);
    `uvm_info("comp2",$sformatf("value of string: stc2=%0s",stc2),UVM_NONE);
  endfunction
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="comp1",uvm_component p=null);
    super.new(n,p);
  endfunction
  comp1 c1;
  comp2 c2;
  int i=12;
  real r=3.14;
  string st="Hello,GitHub...!";
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1=comp1::type_id::create("c1",this);
    c2=comp2::type_id::create("c2",this);
    uvm_config_db#(int)::set(this,"*","key1",i);
    uvm_config_db#(real)::set(this,"*","key1",r);
    uvm_config_db#(string)::set(this,"*","key1",st);
  endfunction
endclass

module test;
  initial run_test("container");
endmodule
