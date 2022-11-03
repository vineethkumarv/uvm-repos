`include "uvm_macros.svh"
import uvm_pkg::*;

class extended_component extends uvm_component;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task training_phase(uvm_phase phase);
endtask

endclass


class uvm_user_phase extends uvm_task_phase;
  function new (string n="post_run");
    super.new(n);
  endfunction
  static const string phase_name="uvm_user_phase";

  virtual function string get_type_name();
  return phase_name;
endfunction

virtual task exec_task(uvm_component comp,uvm_phase phase);
`uvm_info(get_type_name(),"hi",UVM_LOW)
//test t;
//if($cast(t,c))
  //t.post_run_phase(phase);
endtask

static uvm_user_phase p_inst;
static function uvm_user_phase get();
if(p_inst==null) begin
  p_inst=new;
end
return p_inst;
 endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  virtual function void add_phase();
  uvm_domain ud=uvm_domain::get_uvm_domain();
  //uvm_domain ud=uvm_domain::get_uvm_domain();//to insert bw run_phase
  uvm_phase ap=ud.find(uvm_build_phase::get());//inserted after build phase
  ud.add(uvm_user_phase::get(),null,ap,null);
endfunction

function new(string n="test",uvm_component p=null);
  super.new(n,p);
  add_phase();
endfunction
virtual task uvm_user_phase(uvm_phase phase);
`uvm_info("group",$sformatf("in %s phase",phase.get_name()),UVM_MEDIUM);
 endtask
 virtual function void build_phase(uvm_phase phase);
 `uvm_info("group",$sformatf("in %s phase",phase.get_name()),UVM_MEDIUM);
 endfunction
endclass

module one;
//a_phase a;
initial begin
  //a=new();
  //$display(a.get_type_name());
  run_test("test");

end endmodule                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
