module hc595_ctrl
(
	input wire[5:0] selectin,
	input wire[7:0] lightin,
	input wire clk,rstn,
	output reg ds,shcp,stcp,roe
);
reg[1:0] cnt1;
reg[3:0] cnt2;
reg[13:0] collect;
always@(posedge clk or negedge rstn) begin	//roe
	if(!rstn) roe<=1'b0;
	else roe<=1'b0;
end
always@(posedge clk or negedge rstn) begin	//cnt1
	if(!rstn) cnt1<=1'b0;
	else if(cnt1==2'd3) cnt1<=1'b0;
	else cnt1<=cnt1+1'b1;
end
always@(posedge clk or negedge rstn) begin	//shcp
	if(!rstn) shcp<=1'b0;
	else if(cnt1==1'b1) shcp<=1'b1;
	else if(cnt1==2'd3) shcp<=1'b0;
end
always@(posedge clk or negedge rstn) begin	//cnt2
	if(!rstn) cnt2<=4'b0;
	else if(cnt1==2'd2&&cnt2==4'd13) cnt2<=4'b0;
	else if(cnt1==2'd2) cnt2<=cnt2+1'b1;
end	
always@(posedge clk or negedge rstn) begin	//collect
	if(!rstn) collect<=1'b0;
	else if(cnt2==1'b0&&cnt1==2'd3) collect<=
	{lightin[0],lightin[1],lightin[2],lightin[3],
	lightin[4],lightin[5],lightin[6],lightin[7],selectin};
	else if(cnt1==2'd3) collect<=collect>>1'b1;
	else collect<=collect;
end
always@(posedge clk or negedge rstn) begin	//ds
	if(!rstn) ds<=1'b0;
	else if(cnt1==1'b0) ds<=collect[0];
end
always@(posedge clk or negedge rstn) begin	//stcp
	if(!rstn) stcp<=1'b0;
	else if(cnt1==2'd2&&cnt2==4'd13) stcp<=1'b1;
	else stcp<=1'b0;
end
endmodule