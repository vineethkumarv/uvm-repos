`include "uvm_macros.svh"
import uvm_pkg::*;

class ex_object extends uvm_object;
  rand bit [7:0] value1;
  rand int value;
  `uvm_object_utils(ex_object)
  function new(string name="ex_object");
    super.new(name);
  endfunction
  virtual function void do_pack(uvm_packer packer);
  super.do_pack(packer);
  packer.pack_field_int(value1,$bits(value1));
  packer.pack_field_int(value,$bits(value));
endfunction
  virtual function void do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  packer.unpack_field_int($bits(value1));
  packer.unpack_field_int($bits(value));
endfunction
   endclass

   class test extends uvm_test;
     `uvm_component_utils(test) 
     bit bits[];
      int unsigned ints[];
      function new(string name="test",uvm_component parent=null);
        super.new(name,parent);
      endfunction
      ex_object eob;
      virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      eob=ex_object::type_id::create("ex_object");
      eob.pack(bits);
      `uvm_info(get_type_name(),$sformatf("bits are %p",bits),UVM_LOW);
      eob.pack_ints(ints);
      `uvm_info(get_type_name(),$sformatf("ints are %p",ints),UVM_LOW);
    endfunction
  endclass

  module one;
  initial begin
    run_test("test");
  end
  endmodule

 

