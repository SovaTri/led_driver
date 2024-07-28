module display8
#(
	parameter N=16'd49_999,
	parameter N0=8'hC0,	//dp,g2a 
	parameter N1=8'hF9,
	parameter N2=8'hA4,
	parameter N3=8'hB0,
	parameter N4=8'h99,
	parameter N5=8'h92,
	parameter N6=8'h82,
	parameter N7=8'hF8,
	parameter N8=8'h80,
	parameter N9=8'h90
)
(
	input wire[19:0] bin,
	input wire clk,rstn,
	input wire[5:0] dot,
	input wire neg,
	output reg[5:0] select,
	output reg[7:0] light
);
wire[23:0] cn1;
reg[15:0] cnt;
reg cnt_flag;
reg[5:0] bit_flag;
reg[5:0] bit_level;
reg[5:0] neg_flag;
reg[3:0] number;
wire[5:0] bit_dot;
wire[5:0] bit_neg;
reg[5:0] bit_dot_reg;
reg[5:0] bit_final;
wire[5:0] select_c1;
wire[5:0] select_c2;

always@(posedge clk or negedge rstn) begin	//cnt
	if(!rstn) cnt<=16'b0;
	else if(cnt==N) cnt<=16'b0;
	else cnt<=cnt+1'b1;
end
always@(posedge clk or negedge rstn) begin	//cnt_flag
	if(!rstn) cnt_flag<=1'b0;
	else if(cnt==N-1'b1) cnt_flag<=1'b1;
	else cnt_flag<=1'b0;
end
always@(posedge clk or negedge rstn) begin	//bit_flag
	if(!rstn) bit_flag<=6'b00_0001;
	else if(bit_flag==6'b10_0000&&cnt_flag) bit_flag<=6'b00_0001;
	else if(cnt_flag) bit_flag<=bit_flag<<1'b1;
	else bit_flag<=bit_flag;
end
always@(posedge clk or negedge rstn) begin	//bit_level
	if(!rstn) bit_level<=6'b0;
	/*else begin
		bit_level[5]<=(cn1[23:20]>1'b0)?1:0;
		bit_level[4]<=(cn1[19:16]>1'b0)?1:0;
		bit_level[3]<=(cn1[15:12]>1'b0)?1:0;
		bit_level[2]<=(cn1[11:8]>1'b0)?1:0;
		bit_level[1]<=(cn1[7:4]>1'b0)?1:0;
		bit_level[0]<=(cn1[3:0]>1'b0)?1:0;
	end*/
	else if(cn1<=4'd15) bit_level<=6'b00_0001;
	else if(cn1<=8'd255) bit_level<=6'b00_0011;
	else if(cn1<=12'd4095) bit_level<=6'b00_0111;
	else if(cn1<=16'd65535) bit_level<=6'b00_1111;
	else if(cn1<=20'd1048575) bit_level<=6'b01_1111;
	else bit_level<=6'b11_1111;
end
always@(posedge clk or negedge rstn) begin	//neg_flag!!!
	if(!rstn) neg_flag<=6'd0;
	else if(neg)  begin
		/*if(cn1<=4'd15) neg_flag<=6'b00_0010;
		else if(cn1<=8'd255) neg_flag<=6'b00_0100;
		else if(cn1<=12'd4095) neg_flag<=6'b00_1000;
		else if(cn1<=16'd65535) neg_flag<=6'b01_0000;
		else if(cn1<=20'd1048575) neg_flag<=6'b10_0000;
		else neg_flag<=6'b11_1111;*/
		if(bit_level==6'b11_1111||dot>6'b01_1111)
			neg_flag<=6'b11_1111;
		else if(dot<=bit_level) begin
			//neg_flag<=bit_level<<1'b1 + 1'b1 - bit_level;
			if(bit_level==6'b00_0001) neg_flag<=6'b00_0010;
			else if(bit_level==6'b00_0011) neg_flag<=6'b00_0100;
			else if(bit_level==6'b00_0111) neg_flag<=6'b00_1000;
			else if(bit_level==6'b00_1111) neg_flag<=6'b01_0000;
			else if(bit_level==6'b01_1111) neg_flag<=6'b10_0000;
		end
		else if(dot<=6'b00_0011) neg_flag<=6'b00_0100;
		else if(dot<=6'b00_0111) neg_flag<=6'b00_1000;
		else if(dot<=6'b00_1111) neg_flag<=6'b01_0000;
		else if(dot<=6'b01_1111) neg_flag<=6'b10_0000;
	end
	else neg_flag<=6'd0;
end
//assign select=bit_flag&(bit_level|neg_flag|dot);	//select
always@(posedge clk or negedge rstn) begin	//number
	if(!rstn) number<=4'b0;
	else if(bit_flag==6'b00_0001) number<=cn1[3:0];
	else if(bit_flag==6'b00_0010) number<=cn1[7:4];
	else if(bit_flag==6'b00_0100) number<=cn1[11:8];
	else if(bit_flag==6'b00_1000) number<=cn1[15:12];
	else if(bit_flag==6'b01_0000) number<=cn1[19:16];
	else if(bit_flag==6'b10_0000) number<=cn1[23:20];
	else number<=4'b0;
end
assign bit_dot=bit_flag&dot;	//bit_dot
assign bit_neg=bit_flag&neg_flag;	//bit_neg
always@(posedge clk or negedge rstn) begin	//bit_dot_reg
	if(!rstn) bit_dot_reg<=6'd0;
	else bit_dot_reg<=bit_dot;
end
assign select_c1=bit_level|dot;
assign select_c2=bit_level|dot|neg_flag;
always@(posedge clk or negedge rstn) begin	//bit_final
	if(!rstn) bit_final<=6'b0;
	else if(!neg) begin
		if(select_c1<=6'b00_0001) bit_final<=6'b00_0001;
		else if(select_c1<=6'b00_0011) bit_final<=6'b00_0011;
		else if(select_c1<=6'b00_0111) bit_final<=6'b00_0111;
		else if(select_c1<=6'b00_1111) bit_final<=6'b00_1111;
		else if(select_c1<=6'b01_1111) bit_final<=6'b01_1111;
		else if(select_c1<=6'b11_1111) bit_final<=6'b11_1111;
	end
	else if(neg) begin
		if(select_c2<=6'b00_0001) bit_final<=6'b00_0001;
		else if(select_c2<=6'b00_0011) bit_final<=6'b00_0011;
		else if(select_c2<=6'b00_0111) bit_final<=6'b00_0111;
		else if(select_c2<=6'b00_1111) bit_final<=6'b00_1111;
		else if(select_c2<=6'b01_1111) bit_final<=6'b01_1111;
		else if(select_c2<=6'b11_1111) bit_final<=6'b11_1111;
	end
end
always@(posedge clk or negedge rstn) begin	//select!!!
	if(!rstn) select<=6'd0;
	else select<=bit_flag&bit_final;
end
always@(posedge clk or negedge rstn) begin	//light!!!
	if(!rstn) light<=8'b0;
	else if(neg_flag==6'b11_1111) begin
		if(bit_dot_reg==6'b0)
			case(number)
				4'd0:light<=N0 - 8'b1000_0000;
				4'd1:light<=N1 - 8'b1000_0000;
				4'd2:light<=N2 - 8'b1000_0000;
				4'd3:light<=N3 - 8'b1000_0000;
				4'd4:light<=N4 - 8'b1000_0000;
				4'd5:light<=N5 - 8'b1000_0000;
				4'd6:light<=N6 - 8'b1000_0000;
				4'd7:light<=N7 - 8'b1000_0000;
				4'd8:light<=N8 - 8'b1000_0000;
				4'd9:light<=N9 - 8'b1000_0000;
			endcase
		else
			case(number)
				4'd0:light<=N0;
				4'd1:light<=N1;
				4'd2:light<=N2;
				4'd3:light<=N3;
				4'd4:light<=N4;
				4'd5:light<=N5;
				4'd6:light<=N6;
				4'd7:light<=N7;
				4'd8:light<=N8;
				4'd9:light<=N9;
			endcase
	end
	else if((neg_flag!=6'b11_1111)
			&&(bit_neg!=6'b0))
		light<=8'hBF;
	else if(bit_dot_reg!=6'b0)
		case(number)
			4'd0:light<=N0 - 8'b1000_0000;
			4'd1:light<=N1 - 8'b1000_0000;
			4'd2:light<=N2 - 8'b1000_0000;
			4'd3:light<=N3 - 8'b1000_0000;
			4'd4:light<=N4 - 8'b1000_0000;
			4'd5:light<=N5 - 8'b1000_0000;
			4'd6:light<=N6 - 8'b1000_0000;
			4'd7:light<=N7 - 8'b1000_0000;
			4'd8:light<=N8 - 8'b1000_0000;
			4'd9:light<=N9 - 8'b1000_0000;
		endcase
	else
		case(number)
			4'd0:light<=N0;
			4'd1:light<=N1;
			4'd2:light<=N2;
			4'd3:light<=N3;
			4'd4:light<=N4;
			4'd5:light<=N5;
			4'd6:light<=N6;
			4'd7:light<=N7;
			4'd8:light<=N8;
			4'd9:light<=N9;
		endcase
end

bcd bcd8421(
	.bny(bin),
	.clk(clk),
	.rstn(rstn),
	.dcm(cn1)
);
endmodule