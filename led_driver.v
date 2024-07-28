module led_driver
(
	input wire[19:0] data_bny,
	input wire clk,rstn,
	input wire[5:0] dot,
	input wire neg,
	output wire ds,shcp,stcp,roe
);
wire[5:0] cn2;
wire[7:0] cn3;

display8 dp8_ins(
	.bin(data_bny),
	.clk(clk),
	.rstn(rstn),
	.dot(dot),
	.neg(neg),
	.select(cn2),
	.light(cn3)
);
hc595_ctrl hc595_ctrl_ins(
	.selectin(cn2),
	.lightin(cn3),
	.clk(clk),
	.rstn(rstn),
	.ds(ds),
	.shcp(shcp),
	.stcp(stcp),
	.roe(roe)
);
endmodule