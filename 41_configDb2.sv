//uvm_config_db access restriction using path name(inst_name) of the component

//Code-1
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
    uvm_config_db#(int)::set(null,"uvm_test_top.c1","key1",i); //now only comp1 can access config db
    uvm_config_db#(real)::set(null,"uvm_test_top.c1","key1",r);
    uvm_config_db#(string)::set(null,"uvm_test_top.c1","key1",st);
  endfunction
endclass

module test;
  initial run_test("container");
endmodule
