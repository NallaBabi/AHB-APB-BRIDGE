class master_dri extends uvm_driver #(master_trans);
	`uvm_component_utils(master_dri)
	virtual ahb_if.ahb_drv_mp vif;
        master_config m_cfg;
	extern function new(string name = "master_dri",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(master_trans xtn);
endclass


function master_dri::new(string name = "master_dri",uvm_component parent);
 	super.new(name,parent);
endfunction

function void master_dri::build_phase(uvm_phase phase);
            if(!uvm_config_db #(master_config)::get(this,"","master_config",m_cfg))
			`uvm_fatal(get_type_name(),"fatal from master driver")
endfunction

function void master_dri::connect_phase(uvm_phase phase);
 	 vif = m_cfg.vif;
 
endfunction

task master_dri::run_phase(uvm_phase phase);
	super.run_phase(phase);
	@(vif.ahb_drv_cb);
	vif.ahb_drv_cb.Hresetn <=1'b0;
	@(vif.ahb_drv_cb);
	vif.ahb_drv_cb.Hresetn <=1'b1;

       forever begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
        //`uvm_info(get_type_name(),$sformatf("data from mater driver class %s",req.sprint()),UVM_LOW)
	
        seq_item_port.item_done();
	end
endtask

task master_dri::send_to_dut(master_trans xtn);
	
	while(vif.ahb_drv_cb.Hreadyout!==1)
	@(vif.ahb_drv_cb);
	vif.ahb_drv_cb.Haddr <=xtn.Haddr;
	vif.ahb_drv_cb.Hwrite <=xtn.Hwrite;
	vif.ahb_drv_cb.Hburst <=xtn.Hburst;
	vif.ahb_drv_cb.Hsize <=xtn.Hsize;
	vif.ahb_drv_cb.Htrans <=xtn.Htrans;
	vif.ahb_drv_cb.Hreadyin <=xtn.Hreadyin;

	@(vif.ahb_drv_cb);
	while(vif.ahb_drv_cb.Hreadyout!==1)
	@(vif.ahb_drv_cb);


	if(xtn.Hwrite == 1'b1)
		vif.ahb_drv_cb.Hwdata <=xtn.Hwdata;
	else
		vif.ahb_drv_cb.Hwdata <=32'b0;
        `uvm_info(get_type_name(),$sformatf("data from mater driver class %s",xtn.sprint()),UVM_LOW)
	
	
		
endtask


