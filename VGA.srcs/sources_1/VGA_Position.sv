module VGA_Position(
	/*---INPUT---*/
	i_CLK,
	i_VGA_CLK,
	i_button,
	i_RESET,
	err,
	/*---OUTPUT---*/
	width,
	hight
);

/*---I/O declare---*/
input		i_CLK;
input		i_VGA_CLK;
input [3:0] i_button;
input		i_RESET;
input       err;

output reg	[9:0]	width = 320;	// 640pix
output reg	[9:0]	hight = 240;	// 480pix

/*---wire resister*/
wire    RST = i_RESET||err;

reg         up;
reg         down;
reg         left;
reg         right;
reg [25:0]  count;

/*---チャタリング---*/
reg CLK;
always_ff @(posedge i_CLK)begin
	if(count==26'd2500000)begin
		count <= 26'b0;
		CLK <= 1;
	end
	else begin
		count <= count + 1;
		CLK <= 0;
	end
end

/*---button---*/
always_ff @(posedge CLK)begin
	if(i_button[0]) down <= 1;
	else            down <= 0;
end

always_ff @(posedge CLK)begin
    if(i_button[1]) left <= 1;
    else            left <= 0;
end

always_ff @(posedge CLK)begin
	if(i_button[2]) right <= 1;
	else            right <= 0;
end

always_ff @(posedge CLK)begin    
    if(i_button[3]) up <= 1;
    else            up <= 0;
end

/*---move---*/
always_ff @(posedge CLK)begin
    if(RST)begin
	   width <= 320;
	   hight <= 240;
	end
	else if(up)begin
	   if(hight>40)begin
	       hight <= hight - 1;
	   end
	end
	else if(down)begin
	   if(hight <460)begin
			hight <= hight + 1;
	   end
	end
	else if(left)begin
	   if(width>20)begin
	       width <= width - 1;
	   end
	end
	else if(right)begin
	   if(width<620)begin
	       width <= width + 1;
	   end
	end
end

endmodule
