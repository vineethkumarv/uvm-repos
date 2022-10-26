`include "uvm_macros.svh"
import uvm_pkg::*;
class hi extends uvm_test;
  //`uvm_component_utils(hi);
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  /*virtual*/ task run_phase(uvm_phase phase);
  $display("hi");
  `uvm_info("ID anta","message anta hello World!",UVM_MEDIUM);
endtask

endclass


class Packet extends uvm_object;
`uvm_object_utils(Packet);
endclass

