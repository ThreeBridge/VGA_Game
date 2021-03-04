module tb_VGA();
reg SYSCLK;
reg [4:0] BTN;
wire [3:0]  VGA_R;
wire [3:0]  VGA_G;
wire [3:0]  VGA_B;
wire        VGA_HS;
wire        VGA_VS;

VGA vga_i( .* );

initial begin
    forever begin
        #5 SYSCLK = 0;
        #5 SYSCLK = 1;
    end
end

initial begin
    BTN = 5'b0;
    #5;
    BTN[0] = 1;
    #15;
    BTN[0] = 0;
end

endmodule