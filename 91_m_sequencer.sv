/*	
1. m_sequencer
	Ø This is a generic handle of type uvm_sequencer_base.
	Ø It’s always available inside any sequence (inherited from uvm_sequence).
	Ø It does not have compile-time type information about your specific sequencer — so you would need to manually cast it to access custom methods or fields.

*/

//For example:-
`include "uvm_macros.svh"
import uvm_pkg::*;

typedef class seqr;
  
class seq extends uvm_sequence;
  `uvm_object_utils(seq)
  int y;
  seqr sqr;
  
  function new(string name="seq");
    super.new(name);
  endfunction
  task body();
    if($cast(sqr,m_sequencer)) begin
      sqr.sequencer_display(89,52,y);
      $display("the addition of numbers accessed using m_Sequencer is : %0d",y);
    end
  endtask

endclass

class seqr extends uvm_sequencer;
  `uvm_component_utils(seqr)
  function new(string name="seq",uvm_component parent=null);
    super.new(name);
  endfunction
  
  function void sequencer_display(input int a,b,output int y);
    $display("sequncer method accesed using m_sequencer....!");
    y=a+b;
  endfunction
endclass

module top;
  seq s;
  seqr sq;
  
  initial
    begin
      s=new("s");
      sq=new("sq",null);
      s.start(sq);
    end
endmodule
