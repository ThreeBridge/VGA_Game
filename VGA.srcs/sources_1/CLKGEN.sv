module CLKGEN(
    /* INPUT */
    i_CLK,  // 100Mhz
    /* OUTPUT */
    o_CLK
);

/* I/O Declare */
input   i_CLK;

output  o_CLK;

/* reg/wire */
reg CLK50=0;
reg CLK25=0;

always_ff @(posedge i_CLK)begin
    CLK50 <= !CLK50;
end

always_ff @(posedge CLK50)begin
    CLK25 <= ! CLK25;
end

assign o_CLK = CLK25;

endmodule