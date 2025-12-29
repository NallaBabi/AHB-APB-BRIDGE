class master_mon extends uvm_monitor;
	`uvm_component_utils(master_mon)
	virtual ahb_if.ahb_mon_mp vif;
	uvm_analysis_port #(master_trans) analysis_port;
	
        master_config m_cfg;        
	extern function new(string name = "master_mon",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass


function master_mon::new(string name = "master_mon",uvm_component parent);
 	super.new(name,parent);
	analysis_port = new("analysis_port",this);
endfunction

function void master_mon::build_phase(uvm_phase phase);
	   if(!uvm_config_db #(master_config)::get(this,"","master_config",m_cfg))
		`uvm_fatal(get_type_name(),"fatal from master monitor")

endfunction

function void master_mon::connect_phase(uvm_phase phase);
 	 vif = m_cfg.vif;
endfunction


task master_mon::run_phase(uvm_phase phase);
	super.run_phase(phase);
	repeat(2) @(vif.ahb_mon_cb);
	forever collect_data();
endtask

task master_mon::collect_data();
	master_trans xtn;
	xtn = master_trans::type_id::create("xtn");
	while(vif.ahb_mon_cb.Hreadyout!==1)
	@(vif.ahb_mon_cb);
	
	while(vif.ahb_mon_cb.Htrans!==2'b11 && vif.ahb_mon_cb.Htrans!==2'b10)
	@(vif.ahb_mon_cb);
	
	xtn.Haddr = vif.ahb_mon_cb.Haddr;
	xtn.Htrans = vif.ahb_mon_cb.Htrans;
	xtn.Hburst = vif.ahb_mon_cb.Hburst;
	xtn.Hsize = vif.ahb_mon_cb.Hsize;
	xtn.Hreadyin = vif.ahb_mon_cb.Hreadyin;
	xtn.Hwrite = vif.ahb_mon_cb.Hwrite;
	xtn.Hreadyout = vif.ahb_mon_cb.Hreadyout;
	
	@(vif.ahb_mon_cb);
	
	while(vif.ahb_mon_cb.Hreadyout!==1)
	@(vif.ahb_mon_cb);
	while(vif.ahb_mon_cb.Htrans!==2'b11 && vif.ahb_mon_cb.Htrans!==2'b10)
	@(vif.ahb_mon_cb);

	if(xtn.Hwrite ==1'b1)
		xtn.Hwdata  = vif.ahb_mon_cb.Hwdata;
	else
		xtn.Hrdata=vif.ahb_mon_cb.Hrdata;
        `uvm_info(get_type_name(),$sformatf("data from mater monitor class %s",	xtn.sprint()),UVM_LOW)
	analysis_port.write(xtn);

endtask
