`include "uvm_macros.svh"
import uvm_pkg::*;

module top;
  string str;
  int a=102;
  initial
    begin
      str=$sformatf("the value of a is : %0d",a);
      $display("str=%s",str);
    end
endmodule
