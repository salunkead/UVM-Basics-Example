//The use of function uvm_object clone()
/*
1.virtual function uvm_object clone () -> 
  1.The clone method creates and returns an exact copy of this object.
  2.As clone is virtual, derived classes may override this implementation if desired.
*/

//Code-1
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
      f1.randomize;
      $cast(f2,f1.clone()); //or f2=field'(f1.clone()); as the return type of f1.clone method is uvm_object,we need to typecast it to field type
      $display("after clone...........!");
      f1.print();
      f2.print();
    end
endmodule
