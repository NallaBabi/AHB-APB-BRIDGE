class master_top extends uvm_env;
	`uvm_component_utils(master_top)
         master_agt m_agt;

	extern function new(string name = "master_top",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
	
endclass

function master_top::new(string name = "master_top",uvm_component parent);
 	super.new(name,parent);
endfunction

function void master_top::build_phase(uvm_phase phase);
	m_agt = master_agt::type_id::create("m_agt",this);
endfunction

