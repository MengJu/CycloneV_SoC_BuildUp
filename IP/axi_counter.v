//Author : Marco Wu
//Project Created Date : 2022/12/21
//==============================================================
// This is a rxample design which a counter with light wieght AXI.
// CPU, ARM or NIOS II, can access this IP through LW_AXI.
// The purpose is to measure the latency between CPU and FPGA.
//==============================================================

module axi_counter (
//Avalon-MM Simple Slave
	input 	wire			reset_n,
	input	wire			clk,
	input   wire			avs_s0_cs,
	input 	wire [7:0] 		avs_s0_address,
	input 	wire			avs_s0_read,
	output  wire [31:0]		avs_s0_readdata,
	input	wire			avs_s0_write,
	input	wire [31:0]		avs_s0_writedata
// Avalon-ST source
//	output 	wire		out_clock,
//	output	wire			pwm_out
);

//IP Version control.
wire 	[31:0] ip_version = 32'h20220416; 		// Version = create date 20230416.

// Register Table Definition:
reg 	[31:0] ip_version_r;				//Read Only
reg 	[31:0] register_01;				//Read/Write
reg 	[31:0] register_02;
reg 	[31:0] register_03;
wire 	[31:0] register_04;
reg 	[31:0] register_05;
reg 	[31:0] register_06;
reg 	[31:0] register_07;
reg 	[31:0] cnt;

wire		cnt_en_rstn;

always@(posedge clk or negedge reset_n) begin
	if(~reset_n) begin
		ip_version_r  		<= ip_version; 
		register_01    	<= 32'b0;
		register_02 		<= 32'h00001234;
		register_03		<= 32'b0;
//		register_04 		<= 32'h44;
		register_05		<= 32'b0;
		register_06 		<= 32'h55554567;
		register_07 		<= 32'b0;
		
	end
//Avalon Write:
	  //else if (avs_s0_write ==1'b1 && avs_s0_address == 0) ip_version_r 	<= avs_s0_writedata;		
	  else if (avs_s0_cs && avs_s0_write && (avs_s0_address == 1)) register_01 	<= avs_s0_writedata;
	  else if (avs_s0_cs && avs_s0_write && (avs_s0_address == 3)) register_03 	<= avs_s0_writedata;
	  else if (avs_s0_cs && avs_s0_write && (avs_s0_address == 5)) register_05 	<= avs_s0_writedata;
	  else if (avs_s0_cs && avs_s0_write && (avs_s0_address == 7)) register_07 	<= avs_s0_writedata;
	  
//	register_04 <= register_03 + register_05;
end


//Avalon Read:
assign avs_s0_readdata = (avs_s0_read && avs_s0_cs && (avs_s0_address == 0))? ip_version :
                 	  (avs_s0_read && avs_s0_cs && (avs_s0_address == 1))? register_01 :
                  	  (avs_s0_read && avs_s0_cs && (avs_s0_address == 2))? register_02 :
                  	  (avs_s0_read && avs_s0_cs && (avs_s0_address == 3))? register_03 :
                  	  (avs_s0_read && avs_s0_cs && (avs_s0_address == 4))? register_04 :
                  	  (avs_s0_read && avs_s0_cs && (avs_s0_address == 5))? register_05 :
                  	  (avs_s0_read && avs_s0_cs && (avs_s0_address == 6))? register_06 :
                  	  (avs_s0_read && avs_s0_cs && (avs_s0_address == 7))? register_07 : 32'b0;


always@(posedge clk)
begin
	if(~cnt_en_rstn) cnt <= 20'b0;
	else             cnt <= cnt + 1;
end
	
assign register_04 = cnt;
	

	
	
endmodule

