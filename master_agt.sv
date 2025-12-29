class master_agt extends uvm_agent;
	`uvm_component_utils(master_agt)
         master_dri m_dri;
	 master_seqr m_seqr;
	 master_mon m_mon;
	 master_config m_cfg;
	
	extern function new(string name = "master_agt",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function master_agt::new(string name = "master_agt",uvm_component parent);
 	super.new(name,parent);
endfunction

function void master_agt::build_phase(uvm_phase phase);
	if(!uvm_config_db #(master_config)::get(this,"","master_config",m_cfg))
		`uvm_fatal(get_type_name(),"fatal from master agent")

	m_mon = master_mon::type_id::create("m_mon",this);
	if(m_cfg.is_active) begin
	m_dri = master_dri::type_id::create("m_dri",this);	
	m_seqr = master_seqr::type_id::create("m_seqr",this);
	end
endfunction

function void master_agt::connect_phase(uvm_phase phase);
    if(m_cfg.is_active == UVM_ACTIVE)
 		m_dri.seq_item_port.connect(m_seqr.seq_item_export);
endfunction


