//The use of virtual function uvm_object create (string name="")
/*
1.virtual function uvm_object create (string name="")
2.The create method allocates a new object of the same type as this object and returns it via a base uvm_object handle.  
  Every class deriving from uvm_object, directly or indirectly, must implement the create method.
*/

//Code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class Create extends uvm_object;
  rand bit[7:0] a,b,c;
  `uvm_object_utils_begin(Create)
  `uvm_field_int(a,UVM_ALL_ON|UVM_DEC);
  `uvm_field_int(b,UVM_ALL_ON|UVM_DEC);
  `uvm_field_int(c,UVM_ALL_ON|UVM_DEC);
  `uvm_object_utils_end
  function new(string n="f");
    super.new(n);
  endfunction
endclass


module test;
  Create c1;
  initial
    begin
      c1=Create::type_id::create("c1");
      c1.randomize;
      c1.print();
    end
endmodule
