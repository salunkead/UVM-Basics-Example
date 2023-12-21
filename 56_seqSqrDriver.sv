//Sequence -> sequencer -> driver communication
/*
1.class declaration:-
 class uvm_sequencer #(type REQ = uvm_sequence_item,RSP = REQ) extends uvm_sequencer_param_base #(REQ, RSP)
2.Sequencer interface methods:-
   1.virtual task get_next_item (output REQ  t) ->  it is used to retrieve an item from the sequencer's queue
   2.virtual function void item_done (RSP item = null) -> it is used to signal completion back to the sequence
3.uvm_sequence_base sequence item execution methods:-
   1.virtual task wait_for_grant(int item_priority 	 =-1 ,bit lock_request = 0) -> sequence initiates request to current sequencer by calling this method
               //typically it blocks until the grant come from sequencer

*/
