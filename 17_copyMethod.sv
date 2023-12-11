//The use of function void copy (uvm_object rhs)
/*
1.function void copy (uvm_object rhs) -> The copy makes this object a copy of the specified object.
*/

//code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class field extends uvm_object;
  rand bit[7:0] a,b,c;
  `uvm_object_utils_begin(field)
  `uvm_field_int(a,UVM_ALL_ON|UVM_DEC);
  `uvm_field_int(b,UVM_ALL_ON|UVM_DEC);
  `uvm_field_int(c,UVM_ALL_ON|UVM_DEC);
  `uvm_object_utils_end
  function new(string n="f");
    super.new(n);
  endfunction
endclass


module test;
  field f1,f2;
  initial
    begin
      f1=new("f1");
      f2=new("f2");
      f1.randomize;
      f1.print();
      f2.copy(f1);
      $display("after copy...........!");
      f1.print();
      f2.print();
    end
endmodule
