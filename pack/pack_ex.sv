`include "uvm_macros.svh"
import uvm_pkg::*;

class simple_obj extends uvm_object;
  rand int value;
  rand bit [7:0] value1;
  ///rand byte value2[4];
  `uvm_object_utils_begin(simple_obj)
  `uvm_field_int(value,UVM_ALL_ON)
  `uvm_field_int(value1,UVM_ALL_ON)
  //`uvm_field_sarray_int(value2,UVM_ALL_ON)

  `uvm_object_utils_end

  function new(string name= "simple_obj");
    super.new(name);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  simple_obj p_obj;
  bit bitdata[];
  //byte unsigned bytedata[];
  int unsigned intdata[];
  simple_obj unp_obj;
  int packv[3];
  int unpackv[3];
  function  new(string name= "test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    p_obj=simple_obj::type_id::create("p_obj",this);
    //p_obj.randomize();
    packv[0]=p_obj.pack(bitdata);
    //packv[1]=p_obj.pack_bytes(bytedata);
    //packv[2]=p_obj.pack_ints(intdata);
    `uvm_info(get_full_name(),$sformatf("pack bitdata=%p",bitdata),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("packarray[0]=%b",packv[0]),UVM_LOW);
    //`uvm_info(get_full_name(),$sformatf("pack bitdata=%0p",bytedata),UVM_LOW);
    //`uvm_info(get_full_name(),$sformatf("pack bitdata=%0p",intdata),UVM_LOW);

  endfunction
endclass

module one;
initial begin
  run_test("test");
end endmodule


