//The use of function bit compare (uvm_object rhs,uvm_comparer comparer=null)
/*
1.function bit compare (uvm_object rhs,uvm_comparer comparer=null)
2.Deep compares members of this data object with those of the object provided in the rhs (right-hand side) argument, returning 1 on a match, 0 othewise.
3.The compare method is not virtual and should not be overloaded in derived classes.To compare the fields of a derived class, that class should override the do_compare method
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
  field f1,f2,f3;
  initial
    begin
      f1=new("f1");
      f3=new("f3");
      f1.randomize;
      f2=field'(f1.clone());
      $display("after clone...........!");
      f1.print();
      f2.print();
      $display("when we clone objects f1 and f2");
      if(f1.compare(f2))
        $display("class properties of f1 and f2 are equal");
      else
        $display("class properties of f1 and f2 are not equal");
      $display("--------------------------");
      f3.randomize;
      f3.print();
      if(f2.compare(f3))
        $display("class properties of f2 and f3 are equal");
      else
        $display("class properties of f2 and f3 are not equal");
    end
endmodule
