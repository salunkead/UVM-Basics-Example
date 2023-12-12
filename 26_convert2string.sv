//The use of virtual function string convert2string()
//This virtual function is a user-definable hook, called directly by the user, that allows users to provide object information in the form of a string.

//Code-1
`include "uvm_macros.svh"
import uvm_pkg::*;
class object extends uvm_component;
  `uvm_component_utils(object)
  function new(string n="object",uvm_component p=null);
    super.new(n,p);
  endfunction
  int num=120;
  real r=36.65;
  string name="Github";
  time t=52;
  virtual function string convert2string();
    convert2string ={$sformatf("num=%0d r=%0f name=%0s time=%0t",num,r,name,t)};
  endfunction
endclass


module test;
  object obj;
  initial
    begin
      obj=new("obj");
      uvm_report_info("test_module",{"Sending:\n ",obj.convert2string()});
    end
endmodule
