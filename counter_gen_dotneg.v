module counter_gen_dotneg
#(
	parameter CNT_MAX=26'd49_999_999,
	//parameter CNT_MAX=23'd4_999_999,
	//parameter CNT_MAX=23'd499_999,
	//parameter CNT_MAX=23'd49_999,
	parameter GEN_MAX=20'd999_999
)
(
	input wire clk,rstn,
	output reg[19:0] data,
	output reg neg
);
reg[25:0] time_cnt;
reg cnt_flag;
always@(posedge clk or negedge rstn) begin	//time_cnt
	if(!rstn) time_cnt<=1'b0;
	else if(time_cnt==CNT_MAX) time_cnt<=1'b0;
	else time_cnt<=time_cnt+1'b1;
end
always@(posedge clk or negedge rstn) begin	//cnt_flag
	if(!rstn) cnt_flag<=1'b0;
	else if(time_cnt==CNT_MAX-1'b1) cnt_flag<=1'b1;
	else cnt_flag<=1'b0;
end
always@(posedge clk or negedge rstn) begin	//data
	if(!rstn) data<=20'd0;
	else if(cnt_flag==1'b1) begin
		if(data==GEN_MAX) data<=20'd0;
		else data<=data+1'b1;
	end
	else data<=data;
end
always@(posedge clk or negedge rstn) begin	//neg
	if(!rstn) neg<=1'b0;
	else if(cnt_flag&&neg) neg<=1'b0;
	else if(cnt_flag) neg<=1'b1;
	//else neg<=1'b0;
end
endmodule