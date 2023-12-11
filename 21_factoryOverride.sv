//The concept of factory override and new vs create
/*
1.uvm_factory is used to manufacture (create) UVM objects and components
2.in-built functions useful for factory override are
  1.function void set_inst_override_by_type (uvm_object_wrapper original_type,uvm_object_wrapper override_type,string full_inst_path)
  2.function void set_inst_override_by_name (string original_type_name,string override_type_name,string full_inst_path)
  3.function void set_type_override_by_type (uvm_object_wrapper original_type,uvm_object_wrapper override_type,bit replace=1)
  4.function void set_type_override_by_name (string original_type_name,string override_type_name,bit replace=1)
3.we can use any one from4
*/
