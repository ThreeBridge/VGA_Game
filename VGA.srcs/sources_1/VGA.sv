module VGA(
	/*---INPUT---*/
	SYSCLK,
	BTN,
	/*---OUTPUT---*/
	VGA_R,
	VGA_G,
	VGA_B,
	VGA_HS,
	VGA_VS,
	LED
);

/*---I/O declare---*/
input				SYSCLK;	// 100MHz
input [4:0]			BTN;	// active high

output [3:0]		VGA_R;
output [3:0]		VGA_G;
output [3:0]		VGA_B;
output reg			VGA_HS;
output reg			VGA_VS;
output [7:0]        LED;

/*---resister/wire---*/
wire        RESET = BTN[0];
wire        err;

/*---VGA CLOCK 25MHz---*/
wire	VGA_CLK;
CLKGEN CLKGEN(
    .i_CLK(SYSCLK),
    .o_CLK(VGA_CLK)
);

/*---Sync_Genarator---*/
wire s_VGA_HS;
wire s_VGA_VS;
wire [10:0]	 Current_X;
wire [10:0]	 Current_Y;
SyncGEN SyncGEN(
    .VGA_CLK    (VGA_CLK),
    .RESET      (RESET),
    .err        (err),
    .Current_X  (Current_X),
    .Current_Y  (Current_Y),
    .VGA_HS     (s_VGA_HS),
    .VGA_VS     (s_VGA_VS)
);

/*---Point Position---*/
wire [9:0] width;
wire [9:0] hight;
VGA_Position VGA_Position(
	/*---INPUT---*/
	.i_CLK     (SYSCLK),
	.i_VGA_CLK (VGA_CLK),
	.i_button  (BTN[4:1]),
	.i_RESET   (RESET),
	.err       (err),
	/*---OUTPUT---*/
	.width     (width),
	.hight     (hight)
);

/*---Object---*/
wire [9:0] obj_x;
wire [9:0] obj_y;
Object Object(
	.i_CLK	(VGA_CLK),
	.err    (err),
	.o_obj_x(obj_x),
	.o_obj_y(obj_y)
);

check check(
    .i_CLK			(VGA_CLK),
    .i_Position_X	(width),
    .i_Position_Y	(hight),
    .i_Obj_x		(obj_x),
    .i_Obj_y		(obj_y),
    .o_err			(err)
);

/*---VGA Color Pattern---*/
wire [3:0]	 s_VGA_R;
wire [3:0]	 s_VGA_G;
wire [3:0]	 s_VGA_B;
wire [3:0]  s_hit;
VGA_Pattern VGA_Pattern(
	/*---INPUT---*/
	.i_CLK			(SYSCLK),
	.i_VGA_CLK		(VGA_CLK),
	.i_Current_X	(Current_X),
	.i_Current_Y	(Current_Y),
	.i_Position_X	(width),
	.i_Position_Y	(hight),
	.i_Obj_x		(obj_x),
	.i_Obj_y		(obj_y),
	.i_err			(err),
	.i_RESET		(RESET),
	/*---OUTPUT---*/
	.o_Red			(s_VGA_R),
	.o_Green		(s_VGA_G),
	.o_Blue			(s_VGA_B),
	.o_hit          (s_hit)
);

assign VGA_R = (Current_X > 0) ? s_VGA_R : 0 ;
assign VGA_G = (Current_X > 0) ? s_VGA_G : 0 ;
assign VGA_B = (Current_X > 0) ? s_VGA_B : 0 ;

assign VGA_HS = s_VGA_HS;
assign VGA_VS = s_VGA_VS;

assign LED[3:0] = s_hit;

endmodule