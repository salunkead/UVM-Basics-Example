//Field macros for associative array and enum
/*
1.`uvm_field_aa_object_int(ARG,FLAG) ->Implements the data operations for an associative array of uvm_object-based objects indexed by the int data type.
2.`uvm_field_aa_int_int(ARG,FLAG) ->Implements the data operations for an associative array of integral types indexed by the int data type.
3.`uvm_field_aa_int_int_unsigned(ARG,FLAG) ->Implements the data operations for an associative array of integral types indexed by the int unsigned data type.
4.`uvm_field_enum(T,ARG,FLAG) ->T is an enumerated type, ARG is an instance of that type, and FLAG is a bitwise OR of one or more flag.
*/

//Example
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

module test;
  field f;
  initial
    begin
      f=new("f");
      f.print(uvm_default_tree_printer);
    end
endmodule
