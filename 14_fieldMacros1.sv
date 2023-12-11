//Field macros for static array,dynamic array and queue etc
/*
1.for static array's
  1.`uvm_field_sarray_int(ARG,FLAG) ->Implements the data operations for a one-dimensional static array of integrals
  2.`uvm_field_sarray_object(ARG,FLAG) ->Implements the data operations for a one-dimensional static array of uvm_object-based objects.
  3.`uvm_field_sarray_string(ARG,FLAG) ->Implements the data operations for a one-dimensional static array of strings
  4.`uvm_field_sarray_enum(T,ARG,FLAG) ->Implements the data operations for a one-dimensional static array of enums.
2.for dynamic array's
  1.`uvm_field_array_int(ARG,FLAG) ->Implements the data operations for a one-dimensional dynamic array of integrals
  2.rest all same in place of sarray use array and above all of static array's macros
3.for queue's
  1.`uvm_field_queue_int(ARG,FLAG) ->Implements the data operations for a queue of integrals.
  2.rest all are same,just replace sarray with queue
    
*/

//Example

`include "uvm_macros.svh"
import uvm_pkg::*;
class field extends uvm_object;
  int statik[5]='{10,25,63,41,65};
  bit[4:0]queue[$]={1,5,6,8,17};
  string st[5]='{"And","Or","Xor","Not","Nand"};
  int dynamic[];
  `uvm_object_utils_begin(field)
  `uvm_field_sarray_int(statik,UVM_ALL_ON|UVM_DEC)
  `uvm_field_sarray_string(st,UVM_ALL_ON|UVM_STRING)
  `uvm_field_array_int(dynamic,UVM_ALL_ON|UVM_DEC)
  `uvm_field_queue_int(queue,UVM_ALL_ON|UVM_DEC)
  `uvm_object_utils_end
  function new(string n="f");
    super.new(n);
    dynamic=new[5];
    dynamic='{63,87,96,45,98};
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
