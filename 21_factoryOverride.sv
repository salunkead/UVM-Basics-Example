//The concept of factory override 
/*
1.uvm_factory is used to manufacture (create) UVM objects and components
2.factory override allows you to replace one component with another component during runtime.
3.in-built functions useful for factory override are
  1.function void set_inst_override_by_type (uvm_object_wrapper original_type,uvm_object_wrapper override_type,string full_inst_path)
  2.function void set_inst_override_by_name (string original_type_name,string override_type_name,string full_inst_path)
  3.function void set_type_override_by_type (uvm_object_wrapper original_type,uvm_object_wrapper override_type,bit replace=1)
  4.function void set_type_override_by_name (string original_type_name,string override_type_name,bit replace=1)
4.we can use any one from 4
*/

//Code-1

`include "uvm_macros.svh"
import uvm_pkg::*;
class main_class extends uvm_object;
  rand bit[7:0] data,addr;
  `uvm_object_utils_begin(main_class)
  `uvm_field_int(data,UVM_ALL_ON|UVM_DEC)
  `uvm_field_int(addr,UVM_ALL_ON|UVM_DEC)
  `uvm_object_utils_end
  function new(string n="main_class");
    super.new(n);
  endfunction
endclass

class modified_class extends main_class;
  rand bit ack;
  `uvm_object_utils_begin(modified_class)
  `uvm_field_int(ack,UVM_ALL_ON|UVM_DEC)
  `uvm_object_utils_end
  function new(string n="modified_class");
    super.new(n);
  endfunction
endclass

class comp extends uvm_component;
  `uvm_component_utils(comp)
  modified_class mc;
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
    mc=modified_class::type_id::create("mc");
    mc.randomize;
    mc.print();
  endfunction
endclass

module test;
  comp c;
  initial
    begin
      c.set_type_override_by_type(main_class::get_type,modified_class::get_type,1); //here we are replacing main_class with modified class
      c=comp::type_id::create("c",null);
    end
endmodule

//Code-2 Factory override-> create vs new
//trying to replace updated driver component with driver component using new for object creation

`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_component;
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("driver","build phase",UVM_NONE)
  endfunction
endclass

class updated_driver extends driver;
  `uvm_component_utils(updated_driver)
  function new(string n="udrv",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("updated driver","build_phase",UVM_NONE);
  endfunction
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="con",uvm_component p=null);
    super.new(n,p);
  endfunction
  driver drv;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=new("drv",this);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction
  container c;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver::type_id::set_type_override(updated_driver::get_type(),1);
    c=new("c",this);  //Cannot replace updated driver with driver when we use new method for object creation
  endfunction
endclass

module top;
  initial run_test("test");
endmodule

//Code-3
//There are two must criteria for factory override 1.class must be registered with factory 2.object must be created using create method
`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_component;
  `uvm_component_utils(driver)
  function new(string n="drv",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("driver","build phase",UVM_NONE)
  endfunction
endclass

class updated_driver extends driver;
  `uvm_component_utils(updated_driver)
  function new(string n="udrv",uvm_component p=null);
    super.new(n,p);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("updated driver","build_phase",UVM_NONE);
  endfunction
endclass

class container extends uvm_component;
  `uvm_component_utils(container)
  function new(string n="con",uvm_component p=null);
    super.new(n,p);
  endfunction
  driver drv;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=driver::type_id::create("drv",this);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  function new(string n="test",uvm_component p=null);
    super.new(n,p);
  endfunction
  container c;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver::type_id::set_type_override(updated_driver::get_type(),1);
    c=container::type_id::create("c",this);
  endfunction
endclass

module top;
  initial run_test("test");
endmodule
