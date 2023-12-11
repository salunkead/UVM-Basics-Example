//The use of field macro->`uvm_field_object(ARG,FLAG)
/*
1.`uvm_field_object(ARG,FLAG) ->Implements the data operations for an uvm_object-based property.
                                ARG is an object property of the class, and FLAG is a bitwise OR of one or more flag 
*/

//Code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class field extends uvm_object;
  int arr[int];
  typedef enum bit[1:0]{a,b,c,d}state_type;
  state_type s1;
  `uvm_object_utils_begin(field)
  `uvm_field_enum(state_type,s1,UVM_ALL_ON)
  `uvm_field_aa_int_int(arr,UVM_ALL_ON|UVM_DEC)
  `uvm_object_utils_end
  function new(string n="f");
    super.new(n);
    arr[10]=120;
    arr[65]=145;
    arr[47]=451;
    arr[78]=63;
    arr[1]=41;
  endfunction
endclass
class comp extends uvm_component;
  field f;
  `uvm_component_utils_begin(comp)
  `uvm_field_object(f,UVM_ALL_ON);
  `uvm_component_utils_end
  function new(string n="comp",uvm_component p=null);
    super.new(n,p);
    f=new("f");
  endfunction
endclass

module test;
  comp c;
  initial
    begin
      c=new("c",null);
      c.print(uvm_default_tree_printer);
    end
endmodule
