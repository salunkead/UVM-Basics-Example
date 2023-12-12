//virtual function bit do_compare (uvm_object rhs,uvm_comparer comparer)
/*
1.virtual function bit do_compare (uvm_object rhs,uvm_comparer comparer)
2.The do_compare method is the user-definable hook called by the compare method.  
  A derived class should override this method to include its fields in a compare operation.  It should return 1 if the comparison succeeds, 0 otherwise.
*/

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
  virtual function bit do_compare(uvm_object rhs,uvm_comparer comparer);
    object o2;
    bit result;
    $cast(o2,rhs);
    result=super.do_compare(rhs,comparer) &&(a==o2.a)&&(b==o2.b);
    return result;
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
      if(o2.compare(o1))
        $display("object o2 and o1 are equal");
      else
        $display("object o2 and o1 are not equal");
    end
endmodule
