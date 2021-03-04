module xorrand(
    /* INPUT */
    i_CLK,
    /* OUTPUT */
    o_rand
);
/* I/O Declare */
input   i_CLK;

output [9:0] o_rand;

/* parameter */
parameter SEED = 32'h34_56_78_12;

/* Signal */
reg [31:0] x = SEED;
reg [31:0] y;
reg [31:0] z;
reg [1:0]  cnt;

always_ff @(posedge i_CLK)begin
    if(cnt==2'd2) cnt <= 0;
    else          cnt <= cnt + 2'b1;
end

always_ff @(posedge i_CLK)begin
    if(cnt==0)      x <= x ^ (x<<13);
    else if(cnt==1) x <= x ^ (x<<17);
    else            x <= x ^ (x<<15);
end

reg [31:0] randint;
always_ff @(posedge i_CLK)begin
    randint <= x % 10'd620;
end

assign o_rand = (randint<32'd20) ? 10'd20 : randint[9:0];

endmodule