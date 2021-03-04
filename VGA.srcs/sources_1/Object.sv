module Object(
    /* INPUT */
    i_CLK,
    err,
    /* OUTPUT */
    o_obj_x,
    o_obj_y
);
/* I/O Declare */
input   i_CLK;
input   err;

output [9:0] o_obj_x;
output [9:0] o_obj_y;

/* Signal */
reg [24:0]  clk_cnt;
reg [8:0]   fall_sec_cnt;
reg [9:0]   obj_x;      // 障害物のx座標
reg [9:0]   obj_y;      // 障害物のy座標
reg [1:0]   d_err;

wire [9:0]  randint;
wire        set = (clk_cnt==25'b0 && fall_sec_cnt==9'b0) || (d_err[1]||d_err[0]);

always_ff @(posedge i_CLK)begin
    d_err <= {d_err,err};
end

/* fall_time */
always_ff @(posedge i_CLK)begin
    if(err)                         clk_cnt <= 25'b0;
    else if(clk_cnt==25'd390625)    clk_cnt <= 25'b0;
    else                            clk_cnt <= clk_cnt + 25'b1;
end

always_ff @(posedge i_CLK)begin
    if(err)                         fall_sec_cnt <= 9'b0;
    else if(clk_cnt==25'd390625)begin
        if(fall_sec_cnt==9'd420)    fall_sec_cnt <= 9'b0;
        else                        fall_sec_cnt <= fall_sec_cnt + 9'b1;
    end
end

// 障害物の初期位置 : 20 <= x <= 620, y = 20
xorrand xorrand(
    .i_CLK  (i_CLK),
    .o_rand (randint)
);

always_ff @(posedge i_CLK)begin
    if(set)begin
        obj_x <= randint;
        obj_y <= 10'd40;
    end
    else if(clk_cnt==25'd390625)begin
        obj_y <= obj_y + 10'b1;
    end
end

assign o_obj_x = obj_x;
assign o_obj_y = obj_y;

endmodule