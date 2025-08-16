/* 
p_sequncer
	Ø This is a typed handle to your specific sequencer type.
	Ø It’s created by declaring:
                `uvm_declare_p_sequencer(my_sequencer_type)
        inside your sequence class.
After this, p_sequencer will automatically point to the correct sequencer type at runtime, and you can directly access its methods without casting.
*/

//For example:-
`include "uvm_macros.svh"
import uvm_pkg::*;

typedef class seqr;
  
class seq extends uvm_sequence;
  `uvm_object_utils(seq)
  `uvm_declare_p_sequencer(seqr)
  int y;
  function new(string name="seq");
    super.new(name);
  endfunction
  task body();
    p_sequencer.sequencer_display(89,52,y);
    $display("the addition of numbers accessed using p_Sequencer is : %0d",y);
  endtask

endclass

class seqr extends uvm_sequencer;
  `uvm_component_utils(seqr)
  function new(string name="seq",uvm_component parent=null);
    super.new(name);
  endfunction
  
  function void sequencer_display(input int a,b,output int y);
    $display("sequncer method accesed using p_sequencer....!");
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
