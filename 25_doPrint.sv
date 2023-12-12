//do_print method
/*
1.virtual function void do_print (uvm_printer printer)
2.The do_print method is the user-definable hook called by print and sprint that allows users to customize what gets printed or sprinted beyond the field information provided by the `uvm_field_* macros, 
3.uvm_printer is the class which has following methods
  1.virtual function void print_field_int (string name,uvm_integral_t value,int size,uvm_radix_enum radix=UVM_NORADIX,byte scope_separator=".",string type_name="")
  2.virtual function void print_object (string name,uvm_object value,byte scope_separator=".") -> Prints an object.
  3.virtual function void print_string (string name,string value,byte scope_separator=".") ->Prints a string field.
  4.virtual function void print_time (string name,time value,byte scope_separator=".")
  5.virtual function void print_real (string name,real value,byte scope_separator=".")
4.uvm_radix_enum:- it specifies the radix to print or record in.
  1.UVM_BIN	Selects binary (%b) format
  2.UVM_DEC	Selects decimal (%d) format
  3.UVM_OCT	Selects octal (%o) format
  4.UVM_HEX	Selects hexadecimal (%h) format
  5.UVM_STRING	Selects string (%s) format
  6.UVM_TIME	Selects time (%t) format
  7.UVM_ENUM	Selects enumeration value (name) format
  8.UVM_REAL	Selects real (%g) in exponential or decimal format, whichever format results in the shorter printed output
*/

//Code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class object extends uvm_object;
  `uvm_object_utils(object)
  function new(string n="object");
    super.new(n);
  endfunction
  int num=120;
  real r=36.65;
  string name="Github";
  time t=52;
  virtual function void do_print (uvm_printer printer);
    printer.print_field_int ("num",num,$bits(num),UVM_DEC);
    printer. print_string("name",name);
    printer.print_real("r",r);
    printer.print_time("t",t);
  endfunction
endclass

module test;
  object obj;
  initial
    begin
      obj=new("obj");
      obj.print();
    end
endmodule

