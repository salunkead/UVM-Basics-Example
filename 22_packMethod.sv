//Pack pre-defined functions
/*
1.the pack method of the uvm object base class in uvm is responsible for bitwise concatenation of object's properties into an array of bits,bytes,or ints.
2.Pre-defined function used are as follows:-
  1.function int pack (ref bit bitstream[],input uvm_packer packer=null)
  2.function int pack_bytes (ref byte unsigned bytestream[],input uvm_packer packer=null)
  3.function int pack_ints (ref int unsigned intstream[],input uvm_packer packer=null)
 
*/

//Code-1 The use of function int pack (ref bit bitstream[],input uvm_packer packer=null)
`include "uvm_macros.svh"
import uvm_pkg::*;
class object extends uvm_object;
  rand bit[7:0]a,b,c,d;
  `uvm_object_utils_begin(object)
  `uvm_field_int(a,UVM_DEFAULT|UVM_BIN)
  `uvm_field_int(b,UVM_DEFAULT|UVM_BIN)
  `uvm_field_int(c,UVM_DEFAULT|UVM_BIN)
  `uvm_field_int(d,UVM_DEFAULT|UVM_BIN)
  `uvm_object_utils_end
  function new(string n="object");
    super.new(n);
  endfunction
endclass

module test;
  object obj;
  bit arr[];
  initial
    begin
      obj=new("obj");
      obj.randomize;
      obj.print();
      obj.pack(arr);
      $display("packed array is:");
      $display("%p",arr);
    end
endmodule

//Code-2 The use of function int pack_bytes (ref byte unsigned bytestream[],input uvm_packer packer=null)
`include "uvm_macros.svh"
import uvm_pkg::*;
class object extends uvm_object;
  rand bit[7:0]a,b,c,d;
  `uvm_object_utils_begin(object)
  `uvm_field_int(a,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(b,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(c,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(d,UVM_DEFAULT|UVM_DEC)
  `uvm_object_utils_end
  function new(string n="object");
    super.new(n);
  endfunction
endclass

module test;
  object obj;
  byte unsigned arr[];
  initial
    begin
      obj=new("obj");
      obj.randomize;
      obj.print();
      obj.pack_bytes(arr);
      $display("packed array is:");
      $display("%p",arr);
    end
endmodule

//Code-3 The use of function int pack_ints (ref int unsigned intstream[],input uvm_packer packer=null)
`include "uvm_macros.svh"
import uvm_pkg::*;
class object extends uvm_object;
  rand int unsigned a,b,c,d;
  `uvm_object_utils_begin(object)
  `uvm_field_int(a,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(b,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(c,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(d,UVM_DEFAULT|UVM_DEC)
  `uvm_object_utils_end
  function new(string n="object");
    super.new(n);
  endfunction
  constraint constr{a<1000;b<1000;c<1000;d<1000;}
endclass

module test;
  object obj;
  int unsigned arr[];
  initial
    begin
      obj=new("obj");
      obj.randomize;
      obj.print();
      obj.pack_ints(arr);
      $display("packed array is:");
      $display("%p",arr);
    end
endmodule
