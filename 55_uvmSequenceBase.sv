//The uvm_sequence_base class
/*
1.class declaration:-
   1.class uvm_sequence_base extends uvm_sequence_item
   2.virtual class uvm_sequence #(type REQ = uvm_sequence_item,type RSP = REQ) extends uvm_sequence_base
2.Methods:-
  1.function new (string name="uvm_sequence") -> The constructor for uvm_sequence_base.
3.sequence execution methods:-
  1.virtual task start (uvm_sequencer_base  sequencer,uvm_sequence_base  parent_sequence=null,int  this_priority=-1,bit call_pre_post=1)
    1.this method is used to execute sequence
    2.the sequencer arguments tells on which sequencer the sequence to be run
    3.If parent_sequence is null, then this sequence is a root parent, otherwise it is a child of parent_sequence.
      The parent_sequence’s pre_do, mid_do, and post_do methods will be called during the execution of this sequence
    4.By default, the priority of a sequence is the priority of its parent sequence.  If it is a root sequence, its default priority is 100.A different priority may be specified by this_priority.  Higher numbers indicate higher priority.
    5.If call_pre_post is set to 1 (default), then the pre_body and post_body tasks will be called before and after the sequence body is called.   
*/

//Exanple
`include "uvm_macros.svh"
import uvm_pkg::*;
class seq extends uvm_sequence;
  `uvm_object_utils(seq)
  function new(string name="seq");
    super.new(name);
  endfunction
  task pre_start();
    $display("[pre_start] ","this is the user definable callback that is called before pre-body");
    $display("-------------------------------------------------------------------");
  endtask
  task pre_body();
    $display("[pre_body] ","This task is a user-definable callback that is called before the execution of body");
    $display("[pre_body] ","If start is called with call_pre_post set to 0, pre_body is not called");
     $display("-------------------------------------------------------------------");
  endtask
  task body();
    $display("[body] ","This is the user-defined task where the main sequence code resides");
    $display("-------------------------------------------------------------------");
  endtask
  task post_body();
    $display("[post_body] ","This task is a user-definable callback task that is called after the execution of body");
    $display("[post_body] ","If start is called with call_pre_post set to 0, post_body is not called");
     $display("-------------------------------------------------------------------");
  endtask
  task post_start();
    $display("[post_start] ","This task is a user-definable callback that is called after the optional execution of post_body");
     $display("-------------------------------------------------------------------");
  endtask
endclass

module test;
  seq s;
  uvm_sequencer #(seq) sqr;
  initial
    begin
      s=new("s");
      sqr=new("sqr",null);
      s.start(sqr,null,-1,1);
      //s.start(sqr,null,-1,0);  //pre_body and post_body is not called
    end
endmodule
