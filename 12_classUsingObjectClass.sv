//A simple child class using uvm_object base class
/*
1.uvm_object class acts as the base class for all other data and hierarchical classes,providing then with essential functionalities
 key functionality:-
 1.object hierarchy:- it allows building a hierarchical structure within verification environment by enabling inheritance and component relationship.
 2.common utilites:- it provides functions such as print,copy,clone,compare etc for object manipulation and analysis.
2. predefined functions required here in this code is:
   1. function new (string name="") -> Creates a new uvm_object with the given instance name.  If name is not supplied, the object is unnamed.
   2.`uvm_object_utils(class_name) -> it is the set of macros defined in the uvm_object class that provides utility functions like print,clone,copy etc for uvm objects.
*/

//code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class object extends uvm_object;
  `uvm_object_utils(object)  //it is the macro used to register class to factory derived from the uvm_object
  randc bit[7:0]num;
  function new(string name="obj");
    super.new(name);
  endfunction
  function void post_randomize;
    `uvm_info("obj",$sformatf("num=%0d",num),UVM_NONE);
  endfunction
endclass

module test;
  object obj;
  initial
    begin
      obj=new("obj");
      repeat(10)obj.randomize;
    end
endmodule
