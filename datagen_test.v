module datagen_test
(
	input wire clk,rstn,
	input wire[5:0] dot,
	output wire ds,shcp,stcp,roe
);
wire[19:0] cn4;
wire[5:0] cn5;
wire cn6;

assign cn5=~dot;

counter_gen_dotneg cgdn_ins(
	.clk(clk),
	.rstn(rstn),
	.data(cn4),
	.neg(cn6)
);
led_driver led_driver_ins(
	.data_bny(cn4),
	.clk(clk),
	.rstn(rstn),
	.dot(cn5),
	.neg(cn6),
	.ds(ds),
	.shcp(shcp),
	.stcp(stcp),
	.roe(roe)
);
endmodule