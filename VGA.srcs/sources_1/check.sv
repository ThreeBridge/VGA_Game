module check(
    /* INPUT */
    i_CLK,
    i_Position_X,
    i_Position_Y,
    i_Obj_x,
    i_Obj_y,
    /* OUTPUT */
    o_err
);
/* I/O Declare*/
input       i_CLK;
input [9:0] i_Position_X;
input [9:0] i_Position_Y;
input [9:0] i_Obj_x;
input [9:0] i_Obj_y;

output      o_err;

/* Signal */
wire [9:0] dist_x = (i_Position_X < i_Obj_x) ? (i_Obj_x - i_Position_X) : (i_Position_X - i_Obj_x);
wire [9:0] dist_y = (i_Position_Y < i_Obj_y) ? (i_Obj_y - i_Position_Y) : (i_Position_Y - i_Obj_y);
wire hit = dist_x<40&&dist_y<40;

reg [3:0] err;
always_ff @(posedge i_CLK)begin
    if(hit) err <= {err[2:0],1'b1};
    else    err <= 0;
end

assign o_err = (err[1:0]==2'b01);

endmodule