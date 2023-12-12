///The pre-defined unpack functions
/*
1.the unpack methods of the UVM object base class is responsible for extracting data from previously packed bitstream or array of bits,bytes,or ints back into object's properties
2.Decomposes the packed bitstream into individual data values and assigns them to the corresponding object properties
3.pre-defined functions used are:-
  1.function int unpack(ref bit bitstream[],input uvm_packer packer=null)
  2.function int unpack_bytes (ref byte unsigned bytestream[],input uvm_packer packer=null)
  3.function int unpack_ints (ref int unsigned intstream[],input uvm_packer packer=null)
*/

//Code-1 The use of function int unpack_ints (ref int unsigned intstream[],input uvm_packer packer=null)
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
class object2 extends uvm_object;
  int unsigned a1,b1,c1,d1;
  `uvm_object_utils_begin(object2)
  `uvm_field_int(a1,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(b1,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(c1,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(d1,UVM_DEFAULT|UVM_DEC)
  `uvm_object_utils_end
  function new(string n="object2");
    super.new(n);
  endfunction
endclass

module test;
  object obj;
  object2 obj2;
  int unsigned arr[];
  initial
    begin
      obj=new("obj");
      obj2=new("obj2");
      obj.randomize;
      obj.print();
      obj.pack_ints(arr);
      $display("packed array is:");
      $display("%p",arr);
      $display("------------------------------");
      $display("Before unpacking,property values of class object2");
      obj2.print();
      obj2.unpack_ints(arr);
      $display("After unpacking,property values of class object2");
      obj2.print();
    end
endmodule

//Code-2 The use of function int unpack_bytes (ref byte unsigned bytestream[],input uvm_packer packer=null)
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
  object obj,obj2;
  byte unsigned arr[];
  initial
    begin
      obj=new("obj");
      obj2=new("obj2");
      obj.randomize;
      obj.print();
      obj.pack_bytes(arr);
      $display("property values of object 2 before unpack");
      obj2.print();
      $display("property values of object 2 after unpack");
      obj2.unpack_bytes(arr);
      obj2.print();
    end
endmodule
