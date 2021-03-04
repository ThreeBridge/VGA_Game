module SyncGEN(
    /*---INPUT---*/
    VGA_CLK,
    RESET,
    err,
    /*---OUTPUT---*/
    Current_X,
    Current_Y,
    VGA_HS,
    VGA_VS
);
/*---I/O Declare---*/
input       VGA_CLK;
input       RESET;
input       err;

output      Current_X;
output      Current_Y;
output reg  VGA_HS;
output reg  VGA_VS;

/*---parameter---*/
//	Horizontal	Parameter
parameter	H_FRONT	=	16;
parameter	H_SYNC	=	96;
parameter	H_BACK	=	48;
parameter	H_ACT	=	640;
parameter	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
//	Vertical Parameter
parameter	V_FRONT	=	10;
parameter	V_SYNC	=	2;
parameter	V_BACK	=	33;
parameter	V_ACT	=	480;
parameter	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;

/*---reg---*/
reg [10:0] HS_cnt;
reg [10:0] VS_cnt;

wire [10:0]	 Current_X	=	(HS_cnt>=H_ACT)	?	11'b0	:	HS_cnt	;
wire [10:0]	 Current_Y	=	(VS_cnt>=V_ACT)	?	11'b0	:	VS_cnt	;
wire RST = RESET||err;

/*---Horizontal Generator---*/
always_ff @(posedge VGA_CLK)begin
	if(RESET)begin
		HS_cnt <= 11'b0;
	end
	else if(HS_cnt<H_TOTAL-1)begin
		HS_cnt <= HS_cnt + 11'b1;
	end
	else begin
		HS_cnt <= 11'b0;
	end
end

always_ff @(posedge VGA_CLK)begin
	if(RESET)begin
		VGA_HS <= 1;
	end
	else if(HS_cnt==H_ACT+H_FRONT-1)begin
		VGA_HS <= 0;
	end
	else if(HS_cnt==H_ACT+H_FRONT+H_SYNC) begin
		VGA_HS <= 1;
	end
end

/*---Vertical Generator---*/
always_ff @(posedge VGA_CLK)begin
	if(RESET)begin
		VS_cnt <= 11'b0;
	end
    else if(HS_cnt==H_ACT+H_FRONT-1)begin
        if(VS_cnt<V_TOTAL-1)begin
            VS_cnt <= VS_cnt + 11'b1;
        end
        else begin
            VS_cnt <= 11'b0;
	    end
    end
end

always_ff @(posedge VGA_CLK)begin
	if(RESET)begin
		VGA_VS <= 1;
	end
	else if(HS_cnt==H_ACT+H_FRONT-1)begin
	   if(VS_cnt==V_ACT+V_FRONT-1)begin
	       VGA_VS <= 0;
	   end
	   else if(VS_cnt==V_ACT+V_FRONT+V_SYNC-1)begin
	       VGA_VS <= 1;
	   end
    end
end

endmodule