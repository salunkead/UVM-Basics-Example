//virtual function void do_copy (uvm_object rhs)
//Code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class object extends uvm_component;
  `uvm_component_utils(object)
  function new(string n="object",uvm_component p=null);
    super.new(n,p);
  endfunction
  rand bit[7:0]a,b;
  virtual function string convert2string();
    convert2string ={$sformatf("a=%0d b=%0d",a,b)};
  endfunction
  virtual function void do_copy(uvm_object rhs);
    object obj2;
    $cast(obj2,rhs);
    super.do_copy(rhs);
    this.a=obj2.a;
    this.b=obj2.b;
  endfunction
endclass


module test;
  object o1,o2;
  initial
    begin
      o1=new("o1");
      o2=new("o2");
      o1.randomize;
      uvm_report_info("class object o1",{"Sending:\n ",o1.convert2string()});
      o2.copy(o1);
      uvm_report_info("class object o2",{"Sending:\n ",o2.convert2string()});
    end
endmodule
