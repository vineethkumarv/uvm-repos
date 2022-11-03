
`include "uvm_macros.svh"
import uvm_pkg::*;

class rph extends uvm_component;
rand bit a;
rand int k;
rand byte c;
  `uvm_component_utils_begin(rph)
  `uvm_field_int(a,UVM_ALL_ON|UVM_NOPRINT)
  `uvm_field_int(k,UVM_DEFAULT|UVM_DEC)
  `uvm_field_int(c,UVM_DEFAULT)
  `uvm_component_utils_end
  function new(string n="rph",uvm_component p=null);
    super.new(n,p);
  endfunction

endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  rph r;
function new(string n="test",uvm_component p=null);
  super.new(n,p);
endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  r=rph::type_id::create("r",this);
  r.randomize();
  r.print();
  uvm_report_info("hi","u are welcome",UVM_LOW,"ex.sv",10);
endfunction
endclass


module one;
initial begin
  run_test("test");
end endmodule
