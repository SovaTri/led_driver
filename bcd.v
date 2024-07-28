module bcd
(
	input wire clk,rstn,
	input wire[19:0] bny,
	output reg[23:0] dcm
);
reg[43:0] collect;
reg[5:0] timer;
reg flag;
always@(posedge clk or negedge rstn) begin	// timer
	if(!rstn) timer<=1'b0;
	else if(timer==6'd41) timer<=1'b0;
	else timer<=timer+1'b1;
end
always@(posedge clk or negedge rstn) begin	//flag
	if(!rstn) flag<=1'b0;
	else if(timer%2==1'b1) flag<=1'b1;
	else flag<=1'b0;
end
always@(posedge clk or negedge rstn) begin	//collect
	if(!rstn) collect<=1'b0;
	else if(timer==6'b0) collect<={24'b0,bny};
	else if(timer<=6'd40&&flag) begin
		collect[43:40]<=(collect[43:40]>3'd4)?
			(collect[43:40]+2'd3):(collect[43:40]);
		collect[39:36]<=(collect[39:36]>3'd4)?
			(collect[39:36]+2'd3):(collect[39:36]);
		collect[35:32]<=(collect[35:32]>3'd4)?
			(collect[35:32]+2'd3):(collect[35:32]);
		collect[31:28]<=(collect[31:28]>3'd4)?
			(collect[31:28]+2'd3):(collect[31:28]);
		collect[27:24]<=(collect[27:24]>3'd4)?
			(collect[27:24]+2'd3):(collect[27:24]);
		collect[23:20]<=(collect[23:20]>3'd4)?
			(collect[23:20]+2'd3):(collect[23:20]);
	end
	else if(timer<=6'd40&&!flag) collect<=collect<<1'b1;
end
always@(posedge clk or negedge rstn) begin	//dcm
	if(!rstn) dcm<=24'b0;
	else if(timer==6'd40) dcm<=collect[43:20];
	else dcm<=dcm;
end
endmodule
module bcd_old
(
	input wire clk,rstn,
	input wire[19:0] bny,
	output wire[23:0] dcm
);
reg[43:0] collect;
//reg flag;
integer i;
//reg[3:0] b5,b4,b3,b2,b1,b0;
always@(posedge clk or negedge rstn) begin	//transfer
	if(!rstn) collect<=1'b0;
	else begin
		collect<={24'b0,bny};
		//integer i;
		repeat(5'd20) begin
		//integer i
			for(i=5'd23;i<=6'd43;i=i+3'd4)
				if(collect[i -: 4]>3'd4)	//could't use '[i:i-4]'. It's an
					collect[i -: 4]<=collect[i -: 4]+2'd3;	//illegal syntax.
				else						//Coz both 'i' & 'i-4' is veriable.
					collect[i -: 4]<=collect[i -: 4];
			collect<=collect<<1;
		end
		//collect[19:0]<=20'b1111_1111_1111_1111_1111;
	end
end
assign dcm=collect[43:20];
/*always@(posedge clk or negedge rstn) begin	//flag
	if(!rstn) flag<=1'b0;
	else if(collect[19:0]==20'b1111_1111_1111_1111_1111) flag<=1'b1;
	else flag<=1'b0;
end
always@(posedge clk or negedge rstn) begin	//dcm
	if(!rstn) dcm<=1'b0;
	else if(flag==1'b1) dcm<=collect[43:20];
	else dcm<=dcm;
end*/
/*always@(posedge clk or negedge rstn) begin	//dcm
	if(!rstn) dcm<=1'b0;
	elseif(collect[19:0]==20'b1111_1111_1111_1111_1111) dcm<=collect[43:20];
	//else dcm<=dcm;
end*/
endmodule
/*module bcd
(
    input wire clk, rstn,
    input wire [19:0] bny,
    output reg [23:0] dcm
);
    reg [43:0] collect;
    reg flag;
    integer it;

    always @(posedge clk or negedge rstn) begin    //transfer
        if (!rstn) begin
            dcm <= 24'b0;
            flag <= 1'b0;
        end else begin
            collect <= {24'b0, bny}; // 将bny放在collect的低位
            repeat(20) begin
                for (it = 23; it <= 43; it = it + 4) begin
                    if (collect[it-:4] > 4)
                        collect[it-:4] <= collect[it-:4] + 3;
                end
                collect <= collect << 1;
            end
            dcm <= collect[43:20];
            flag <= (collect[19:0] == 20'b1111_1111_1111_1111_1111) ? 1'b1 : 1'b0;
        end
    end
endmodule*/
/*module bcd
(
    input wire clk, rstn,
    input wire [19:0] bny,
    output reg [23:0] dcm
);
    reg [43:0] collect;
    reg flag;
    integer i;

    always @(posedge clk or negedge rstn) begin //transfer
        if (!rstn) begin
            dcm <= 24'b0;
            flag <= 1'b0;
            collect <= 44'b0;
        end else begin
            if (!flag) begin
                collect <= {24'b0, bny}; // 将bny放在collect的低位
                repeat(20) begin
                    for (i = 23; i <= 43; i = i + 4) begin
                        if (collect[i -: 4] > 4)
                            collect[i -: 4] <= collect[i -: 4] + 3;
                    end
                    collect <= collect << 1;
                end
                flag <= 1'b1;
            end else begin
                dcm <= collect[43:20];
            end
        end
    end

    always @(posedge clk or negedge rstn) begin //flag reset
        if (!rstn) 
            flag <= 1'b0;
    end
endmodule*/
/*module bcd
(
    input wire clk, rstn,
    input wire [19:0] bny,
    output reg [23:0] dcm
);
    reg [43:0] collect;
    reg flag;
    integer i;

    always @(posedge clk or negedge rstn) begin //transfer
        if (!rstn) begin
            dcm <= 24'b0;
            flag <= 1'b0;
            collect <= 44'b0;
        end else begin
            if (!flag) begin
                collect <= {24'b0, bny}; // 将bny放在collect的低位
                repeat(20) begin
                    for (i = 23; i <= 43; i = i + 4) begin
                        if (collect[i -: 4] > 4)
                            collect[i -: 4] <= collect[i -: 4] + 3;
                    end
                    collect <= collect << 1;
                end
                flag <= 1'b1;
            end else begin
                dcm <= collect[43:20];
            end
        end
    end
endmodule*/
/*module bcd
(
    input wire clk, rstn,
    input wire [19:0] bny,
    output reg [23:0] dcm
);
    reg [43:0] collect;
    integer i;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            collect <= 44'b0;
        end else begin
            collect <= {24'b0, bny};
            repeat (20) begin
                for (i = 23; i <= 43; i = i + 4) begin
                    if (collect[i -: 4] > 4)
                        collect[i -: 4] <= collect[i -: 4] + 3;
                end
                collect <= collect << 1;
            end
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            dcm <= 24'b0;
        end else begin
            dcm <= collect[43:20];
        end
    end
endmodule*/