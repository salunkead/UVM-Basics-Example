//Identification Methods of uvm_object base class
/////using get_name,get_full_name and get_type_name()
/*
The pre-defined functions are as follows
1.virtual function void set_name (string name) ->Sets the instance name of this object, overwriting any previously given name
2.virtual function string get_name () ->Returns the name of the object, as provided by the name argument in the new constructor or set_name method.
3.virtual function string get_full_name () ->Returns the full hierarchical name of this object.  
4.virtual function int get_inst_id () ->Returns the object’s unique, numeric instance identifier
5.static function int get_inst_count() ->Returns the current value of the instance counter, which represents the total number of uvm_object-based objects that have been allocated in simulation. 
6.static function uvm_object_wrapper get_type () ->Returns the type-proxy (wrapper) for this object. ex-class_name::get_type()
7.virtual function uvm_object_wrapper get_object_type () ->This method is the same as the static get_type method, but uses an already allocated object to determine the type-proxy to access (instead of using the static object).
8.virtual function string get_type_name () ->This function returns the type name of the object, 
*/

//Code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class object extends uvm_object;
  `uvm_object_utils(object)
  function new(string n="object");
    super.new(n);
    $display("the name is: %s",get_name());
    $display("the full name is: %s",get_full_name());
    $display("unique id of object is: %0d",get_inst_id ());
    $display("number of instance created are: %0d",get_inst_count());
    $display("the type name is: %s",get_type_name ());
    $display("----------------------------------------------------");
  endfunction
endclass

class comp extends uvm_component;
  `uvm_component_utils(comp)
  object obj;
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
    obj=new("obj");
    $display("the name is: %s",get_name());
    $display("the full name is: %s",get_full_name());
    $display("unique id of object is: %0d",get_inst_id ());
    $display("number of instance created are: %0d",get_inst_count());
    $display("the type name is: %s",get_type_name ());
  endfunction
endclass

module test;
  comp p;
  initial
    begin
      $display("type is : %p",comp::get_type());
      $display("----------------------------------------------------");
      p=new("p",null);
    end
endmodule
