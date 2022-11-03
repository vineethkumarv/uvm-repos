`include "uvm_macros.svh"
import uvm_pkg::*;

class extended_component extends uvm_component; 
  `uvm_component_utils(extended_component)
  function new (string name, uvm_component parent); 
    super.new(name, parent); 
  endfunction
  virtual task training_phase(uvm_phase phase); // User-defined phase task 
endtask 

  endclass

  class my_training_phase extends uvm_task_phase; // User-defined phase class  
    protected function new (string name = ""); 
    super.new(name); 
  endfunction
  static local my_training_phase m_singleton_inst; 
  static function my_training_phase get; 
  if (m_singleton_inst == null) 
    m_singleton_inst = new("my_training_phase"); 
    return m_singleton_inst; 
  endfunction 

  task exec_task(uvm_component comp, uvm_phase phase); 
    extended_component c; 
    $display("hi");
    if ($cast(c, comp)) 
      c.training_phase(phase);  // Call the overridden user-defined phase task 
    endtask 
  endclass


  class env extends extended_component; 
    `uvm_component_utils(env)
    extended_component m_env1;
    function new(string n="",uvm_component p=null) ;
      super.new(n,p);
    endfunction
    task training_phase(uvm_phase phase); 
      phase.raise_objection(this); 
      // Consume time 
      phase.drop_objection(this); 
    endtask
    function void build_phase(uvm_phase phase); 
      uvm_phase schedule; 
      //m_env1 = extended_component::type_id::create("m_env1", this); 
      schedule = uvm_domain::get_uvm_schedule(); 
      schedule.add(my_training_phase::get(), .after_phase(uvm_configure_phase::get()),.before_phase(uvm_main_phase::get()));
    endfunction
  endclass

  module one;
  initial begin
    run_test("env");
  end
  endmodule
