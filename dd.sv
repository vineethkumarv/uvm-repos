`include "uvm_macros.svh"
import uvm_pkg::*;

class test extends uvm_test;
  rand int a,b,c;
  function new(string n="test",uvm_component p=this);
    super.new(n,p);
   // this.hi;
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.print();
    `uvm_info(get_full_name(),"hello",UVM_LOW);
  //  return 1;
  endfunction
  `uvm_component_utils_begin(test)
  `uvm_field_int(a,UVM_DEFAULT);
  `uvm_field_int(b,UVM_DEFAULT);
  //`uvm_field_int(hi,UVM_DEFAULT);
  `uvm_component_utils_end
endclass

module one;
initial begin
  run_test("test");
end
endmodule
