
`include "uvm_macros.svh"
import uvm_pkg::*;

class simple_obj extends uvm_object;
  rand bit [2:0] switch;
 rand byte char;
  rand int value;
  `uvm_object_utils_begin(simple_obj)
  `uvm_field_int(value,UVM_DEFAULT)
  `uvm_field_int(switch,UVM_ALL_ON)
  `uvm_field_int(char,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name= "simple_obj");
    super.new(name);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  simple_obj p_obj;
  bit bitdata[];
  int unsigned intdata[];
  byte unsigned bytedata[];
  simple_obj unp_obj;
  function  new(string name= "test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    p_obj=simple_obj::type_id::create("p_obj",this);
  //  repeat (3)begin
    p_obj.randomize();
    p_obj.pack_ints(intdata);
   p_obj.pack(bitdata);
   p_obj.pack_bytes(bytedata);

    `uvm_info(get_full_name(),$sformatf("pack bitdata=%p",bitdata),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("pack intdata=%p",intdata),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("pack bytedata=%p",bytedata),UVM_LOW);
    $display("size is intdata is %0d and value is %0d",intdata.size(),p_obj.value);
    $display("size is bitdata is %0d and values are %p",bitdata.size(),p_obj.switch);
    $display("size is bytedata is %0d and value is %0d",bytedata.size(),p_obj.char);
    p_obj.unpack_ints(intdata);
    `uvm_info(get_full_name(),$sformatf("unpack intdata=%p",intdata),UVM_LOW);
   p_obj.unpack(bitdata);
    `uvm_info(get_full_name(),$sformatf("unpack bitdata=%p",bitdata),UVM_LOW);
   p_obj.unpack_bytes(bytedata);
    `uvm_info(get_full_name(),$sformatf("unpack bytedata=%p",bytedata),UVM_LOW);

  //end
  endfunction
endclass

module one;
initial begin
  run_test("test");
end  endmodule
