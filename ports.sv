class trans extends uvm_sequence_item;
  rand bit [7:0]a;
  rand bit [7:0]b;
  `uvm_object_utils_begin(trans)
  `uvm_field_int(a,UVM_ALL_ON)
  `uvm_field_int(b,UVM_ALL_ON)
  `uvm_object_utils_end
  function new (string n="transaction");
    super.new(n);
  endfunction
endclass

class seq extends uvm_sequence#(trans);
endclass

class compA extends uvm_component;
  trans t;
  `uvm_component_utils(compA)
  uvm_blocking_put_port#(trans) pport;

  function new(string n="compA",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  pport=new("pport",this);
  t=trans::type_id::create("t",this);
endfunction

virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
t.randomize();
pport.put(t);
endtask

endclass

class compB extends uvm_component;
  //trans t;
  `uvm_component_utils(compB)
  uvm_blocking_put_imp#(trans,compB) iport;

  function new(string n="compB",uvm_component p=null);
    super.new(n,p);
  endfunction
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  iport=new("iport",this);
  //t=trans::type_id::create("t",this);
endfunction

/*virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
//t.randomize();
iport.put(t);
endtask*/
virtual task put(trans t);
t.print();
endtask


endclass 


class envir extends uvm_env;
  compA cA;
  compB cB;
 
  `uvm_component_utils(envir)
  function new(string n="compB",uvm_component p=null);
    super.new(n,p);
  endfunction
 virtual function build_phase(uvm_phase phase);
 super.build_phase(phase);
 cA=compA::type_id::create("cA",this);
 cB=compB::type_id::create("cB",this);
 endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cA.pport.connect(cB.iport);
cB.print();
endfunction
endclass
