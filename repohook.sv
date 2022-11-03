`include "uvm_macros.svh"
import uvm_pkg::*;

class rph extends uvm_component;

  `uvm_component_utils(rph)
  function new(string n="rph",uvm_component p=null);
    super.new(n,p);
  endfunction

  virtual function bit report_info_hook(string id, string message, int verbosity, string filename, int line);
  super.report_info_hook( id, message, verbosity, filename, line);
  `uvm_info(id,message,verbosity);
  $display("hi");
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
  uvm_report_info("hi","u are welcome",UVM_LOW,"ex.sv",10);
  r.report_info_hook("hi","u are welcome",UVM_LOW,"ex.sv",10);
endfunction
endclass


module one;
initial begin
  run_test("test");
end endmodule
