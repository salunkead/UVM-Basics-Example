//Field macros:-int,string,real
/*
1.field macros are the predefined code that automatically implements common object manipulation functionalities for class properties.
2.it eliminates the need to write repeatative code for tak like printing,comparison etc.
3.`uvm_field_*(* can be int,string,real etc) is used inside `uvm_*_utils_begin and `uvm_*_utils_end(* can be object or component)
4.syntax:- `uvm_field_*(arg,flag) 
  1.arg-arguments/variables whose type is compatible with the macro being used
  ex:-if variables is of type int,reg,bit,logic etc,the macros should be `uvm_field_int()
  2.flag:-some of the flags from verification academy website are as follows
  UVM_ALL_ON	Set all operations on (default).
  UVM_DEFAULT	Use the default flag settings.
  UVM_NOCOPY	Do not copy this field.
  UVM_NOCOMPARE	Do not compare this field.
  UVM_NOPRINT	Do not print this field.
  UVM_NOPACK	Do not pack or unpack this field.

  A radix for printing and recording can be specified by OR’ing one of the following constants in the FLAG argument
  UVM_BIN	Print / record the field in binary (base-2).
  UVM_DEC	Print / record the field in decimal (base-10).
  UVM_UNSIGNED	Print / record the field in unsigned decimal (base-10).
  UVM_OCT	Print / record the field in octal (base-8).
  UVM_HEX	Print / record the field in hexidecimal (base-16).
  UVM_STRING	Print / record the field in string format.
  UVM_TIME	Print / record the field in time format.
*/

//code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class field extends uvm_object;
  reg[3:0]r=12;
  int n=123;
  real rl=32.65;
  string name="GitHub";
  bit[7:0]bt=245;
  logic[4:0]lc=30;
  time t=56;
  `uvm_object_utils_begin(field)
  `uvm_field_int(r,UVM_ALL_ON|UVM_DEC)
  `uvm_field_int(n,UVM_ALL_ON|UVM_DEC)
  `uvm_field_int(bt,UVM_ALL_ON|UVM_DEC)
  `uvm_field_int(lc,UVM_ALL_ON|UVM_DEC)
  `uvm_field_int(t,UVM_ALL_ON|UVM_TIME)
  `uvm_field_string(name,UVM_ALL_ON)
  `uvm_field_real(rl,UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string n="f");
    super.new(n);
  endfunction
endclass

module test;
  field f;
  initial
    begin
      f=new("f");
      f.print(); //we can change the printing fromat by passing arguments to the print function->default is uvm_default_table_printer
      //f.print(uvm_default_tree_printer); //uvm_default_tree_printer will print in tree format
    end
endmodule

/*
1.print formats
 uvm_default_table_printer 
 uvm_default_tree_printer
 uvm_default_line_printer 
 
*/
