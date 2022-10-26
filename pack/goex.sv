
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_object extends uvm_object;
  rand bit [7:0]value;
  rand byte unsigned data[4:0];
  rand int  addr;
  `uvm_object_utils_begin(my_object)
  `uvm_field_int(value,UVM_ALL_ON)
  `uvm_field_sarray_int(data,UVM_DEFAULT)
  `uvm_field_int(addr,UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name= "my_object");
    super.new(name);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  function  new(string name= "test",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  my_object obj;
  bit bits[];
  byte unsigned bytes[];
  int unsigned ints[];
  my_object unp_obj;
  virtual function void build_phase(uvm_phase phase);
  obj=my_object::type_id::create("my_object",this);
  obj.randomize();
  obj.print();
  $display("before pack values of byte are %p and stream bytes is %p",obj.data,bytes);
  obj.pack(bits);
  obj.pack_bytes(bytes);
  $display("after pack values of byte are %p and stream bytes is %p",obj.data,bytes);
  obj.pack_ints(ints);
  `uvm_info(get_type_name(),$sformatf("pack bitdata=%p",bits),UVM_LOW);
  `uvm_info(get_type_name(),$sformatf("pack bytedata=%p",bytes),UVM_LOW);
  `uvm_info(get_type_name(),$sformatf("pack intdata=%p",ints),UVM_LOW);
  $display("----------------------------------------------------------");
  obj.unpack(bits);
  obj.unpack_bytes(bytes);
  obj.unpack_ints(ints);
  `uvm_info(get_type_name(),$sformatf("unpack bitdata=%p",bits),UVM_LOW);
  `uvm_info(get_type_name(),$sformatf("unpack bytedata=%p",bytes),UVM_LOW);
  `uvm_info(get_type_name(),$sformatf("unpack intdata=%p",ints),UVM_LOW);
endfunction
endclass

module one;
initial begin
  run_test("test");
end endmodule


