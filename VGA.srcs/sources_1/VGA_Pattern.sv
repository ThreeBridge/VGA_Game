module VGA_Pattern(
	/*---INPUT---*/
	i_CLK,
	i_VGA_CLK,
	i_Current_X,
	i_Current_Y,
	i_Position_X,
	i_Position_Y,
	i_Obj_x,
	i_Obj_y,
	i_err,
	i_RESET,
	/*---OUTPUT---*/
	o_Red,
	o_Green,
	o_Blue,
	o_hit
);

/*---I/O declare---*/
input		 	i_CLK;
input		 	i_VGA_CLK;
input [10:0] 	i_Current_X;
input [10:0] 	i_Current_Y;
input [9:0]	 	i_Position_X;
input [9:0]	 	i_Position_Y;
input [9:0]  	i_Obj_x;
input [9:0]	 	i_Obj_y;
input			i_err;
input		 	i_RESET;

output reg [3:0] o_Red;
output reg [3:0] o_Green;
output reg [3:0] o_Blue;
output [3:0]    o_hit;

/*---Move Point---*/
wire score_area = (i_Current_Y<20&&i_Current_X<640-16);
wire scorenum_area = (i_Current_Y<20&&i_Current_X>=640-16);
wire bar = (i_Current_Y==20);
wire X_en = (i_Current_X>=i_Position_X-20 && i_Current_X<i_Position_X+20);
wire Y_en = (i_Current_Y>=i_Position_Y-20 && i_Current_Y<i_Position_Y+20);
wire obj_x_en = (i_Current_X>=i_Obj_x-20 && i_Current_X<i_Obj_x+20);
wire obj_y_en = (i_Current_Y>=i_Obj_y-20 && i_Current_Y<i_Obj_y+20);

reg [3:0] hit;
wire [15:0] num_Y = number(hit,i_Current_Y);
wire [4:0] num_d = (i_Current_X<640-16) ? 4'd0 : 640 - i_Current_X - 1;
wire num_en = num_Y[num_d];

reg [19:0] [0:639-16] score_disp;
wire score_disp_en = score_disp[i_Current_Y][i_Current_X];

always_ff@(posedge i_VGA_CLK)begin
    if(i_RESET)begin
	   o_Red   <= 4'h0;
	   o_Green <= 4'h0;
	   o_Blue  <= 4'h0;
	end
	else begin
	    if(score_area)begin
	        o_Red   <= (score_disp_en) ? 4'd15 : 4'd0;
	        o_Green <= (score_disp_en) ? 4'd15 : 4'd0;
	        o_Blue  <= (score_disp_en) ? 4'd15 : 4'd0;
	    end
	    else if(scorenum_area)begin
	        o_Red   <= (num_en) ? 4'd15 : 4'd0;
	        o_Green <= (num_en) ? 4'd15 : 4'd0;
	        o_Blue  <= (num_en) ? 4'd15 : 4'd0;
	    end
	    else if(bar)begin
	        o_Red   <= 4'd3;
            o_Green <= 4'd3;
            o_Blue  <= 4'd15;
	    end
		else if(X_en && Y_en) begin
		  	o_Red   <= 4'd15;
		  	o_Green <= 4'd15;
		  	o_Blue  <= 4'd15;
	   	end
	   	else if(obj_x_en && obj_y_en)begin
			o_Red	<= 4'd14;
			o_Green	<= 4'd4;
			o_Blue	<= 4'd6;
	   	end
	   	else begin
	       	o_Red	<=	0;
	       	o_Green	<=	0;
	    	o_Blue	<=	0;
		end
	end
end

always_ff @(posedge i_VGA_CLK)begin
    if(i_RESET)begin
        hit <= 0;
    end
    else if(i_err)begin
        if(hit==9)  hit <= 0;
        else        hit <= hit + 1;
    end
end

assign o_hit = hit;

always_ff @(posedge i_VGA_CLK)begin
    score_disp[0]  <= 640'h00;
    score_disp[1]  <= 640'h00;
    score_disp[2]  <= 640'h00000FE003FC01F8030E07C000;
    score_disp[3]  <= 640'h00001FF807FE03FE033E1FF000;
    score_disp[4]  <= 640'h00003FF80FFE07FF037C3FF800;
    score_disp[5]  <= 640'h000038001E000E0703E0701C00;
    score_disp[6]  <= 640'h000030003C001C038380E00C00;
    score_disp[7]  <= 640'h0000300038001C018300E00C00;
    score_disp[8]  <= 640'h00001C00300018018300FFFE00;
    score_disp[9]  <= 640'h00000FE0300018018300FFFC00;
    score_disp[10] <= 640'h000000F8300018018300FFF800;
    score_disp[11] <= 640'h0000001C300018018300C00000;
    score_disp[12] <= 640'h0000000C300018018300C00000;
    score_disp[13] <= 640'h0000000C38001C038300E00000;
    score_disp[14] <= 640'h0000301C1C000E070300700C00;
    score_disp[15] <= 640'h00000FF80FFC07FE03003FFC00;
    score_disp[16] <= 640'h00001FF007FC03FC03001FF800;
    score_disp[17] <= 640'h000007C001F001F8030003C000;
    score_disp[18] <= 640'h00;
    score_disp[19] <= 640'h00;
end

function [15:0] number;
input [3:0]  num;
input [10:0] i_Y;
    case(num)
    4'd0 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h03E0;
        11'd4  : number = 16'h0410;
        11'd5  : number = 16'h0808;
        11'd6  : number = 16'h0808;
        11'd7  : number = 16'h1004;
        11'd8  : number = 16'h1004;
        11'd9  : number = 16'h1004;
        11'd10 : number = 16'h1004;
        11'd11 : number = 16'h1004;
        11'd12 : number = 16'h1004;
        11'd13 : number = 16'h0808;
        11'd14 : number = 16'h0808;
        11'd15 : number = 16'h0410;
        11'd16 : number = 16'h03E0;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    4'd1 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h0180;
        11'd4  : number = 16'h0380;
        11'd5  : number = 16'h0780;
        11'd6  : number = 16'h0180;
        11'd7  : number = 16'h0180;
        11'd8  : number = 16'h0180;
        11'd9  : number = 16'h0180;
        11'd10 : number = 16'h0180;
        11'd11 : number = 16'h0180;
        11'd12 : number = 16'h0180;
        11'd13 : number = 16'h0180;
        11'd14 : number = 16'h0180;
        11'd15 : number = 16'h0180;
        11'd16 : number = 16'h07E0;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    4'd2 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h03C0;
        11'd4  : number = 16'h0660;
        11'd5  : number = 16'h0C30;
        11'd6  : number = 16'h0830;
        11'd7  : number = 16'h0010;
        11'd8  : number = 16'h0010;
        11'd9  : number = 16'h0010;
        11'd10 : number = 16'h0030;
        11'd11 : number = 16'h0060;
        11'd12 : number = 16'h00C0;
        11'd13 : number = 16'h0180;
        11'd14 : number = 16'h0300;
        11'd15 : number = 16'h0600;
        11'd16 : number = 16'h0FF8;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    4'd3 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h03C0;
        11'd4  : number = 16'h0630;
        11'd5  : number = 16'h0C18;
        11'd6  : number = 16'h0818;
        11'd7  : number = 16'h0010;
        11'd8  : number = 16'h0030;
        11'd9  : number = 16'h0010;
        11'd10 : number = 16'h00E0;
        11'd11 : number = 16'h00F0;
        11'd12 : number = 16'h0018;
        11'd13 : number = 16'h0008;
        11'd14 : number = 16'h0808;
        11'd15 : number = 16'h0C18;
        11'd16 : number = 16'h07F0;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    4'd4 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h1080;
        11'd4  : number = 16'h1080;
        11'd5  : number = 16'h1080;
        11'd6  : number = 16'h1080;
        11'd7  : number = 16'h1080;
        11'd8  : number = 16'h1080;
        11'd9  : number = 16'h1080;
        11'd10 : number = 16'h1080;
        11'd11 : number = 16'h1FF1;
        11'd12 : number = 16'h0080;
        11'd13 : number = 16'h0080;
        11'd14 : number = 16'h0080;
        11'd15 : number = 16'h0080;
        11'd16 : number = 16'h0080;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    4'd5 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h0FF0;
        11'd4  : number = 16'h0800;
        11'd5  : number = 16'h0800;
        11'd6  : number = 16'h0800;
        11'd7  : number = 16'h0800;
        11'd8  : number = 16'h0800;
        11'd9  : number = 16'h0FF0;
        11'd10 : number = 16'h0010;
        11'd11 : number = 16'h0010;
        11'd12 : number = 16'h0010;
        11'd13 : number = 16'h0010;
        11'd14 : number = 16'h0010;
        11'd15 : number = 16'h0FF0;
        11'd16 : number = 16'h0;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    4'd6 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h0FF0;
        11'd4  : number = 16'h0800;
        11'd5  : number = 16'h0800;
        11'd6  : number = 16'h0800;
        11'd7  : number = 16'h0800;
        11'd8  : number = 16'h0800;
        11'd9  : number = 16'h0FF0;
        11'd10 : number = 16'h0810;
        11'd11 : number = 16'h0810;
        11'd12 : number = 16'h0810;
        11'd13 : number = 16'h0810;
        11'd14 : number = 16'h0810;
        11'd15 : number = 16'h0FF0;
        11'd16 : number = 16'h0;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    4'd7 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h0FF0;
        11'd4  : number = 16'h0810;
        11'd5  : number = 16'h0810;
        11'd6  : number = 16'h0810;
        11'd7  : number = 16'h0810;
        11'd8  : number = 16'h0810;
        11'd9  : number = 16'h0810;
        11'd10 : number = 16'h0010;
        11'd11 : number = 16'h0010;
        11'd12 : number = 16'h0010;
        11'd13 : number = 16'h0010;
        11'd14 : number = 16'h0010;
        11'd15 : number = 16'h0010;
        11'd16 : number = 16'h0;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    4'd8 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h0FF0;
        11'd4  : number = 16'h0810;
        11'd5  : number = 16'h0810;
        11'd6  : number = 16'h0810;
        11'd7  : number = 16'h0810;
        11'd8  : number = 16'h0810;
        11'd9  : number = 16'h0FF0;
        11'd10 : number = 16'h0810;
        11'd11 : number = 16'h0810;
        11'd12 : number = 16'h0810;
        11'd13 : number = 16'h0810;
        11'd14 : number = 16'h0810;
        11'd15 : number = 16'h0FF0;
        11'd16 : number = 16'h0;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    4'd9 : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h0FF0;
        11'd4  : number = 16'h0810;
        11'd5  : number = 16'h0810;
        11'd6  : number = 16'h0810;
        11'd7  : number = 16'h0810;
        11'd8  : number = 16'h0810;
        11'd9  : number = 16'h0FF0;
        11'd10 : number = 16'h0010;
        11'd11 : number = 16'h0010;
        11'd12 : number = 16'h0010;
        11'd13 : number = 16'h0010;
        11'd14 : number = 16'h0010;
        11'd15 : number = 16'h0FF0;
        11'd16 : number = 16'h0;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    default : begin
        case(i_Y)
        11'd0 :  number = 16'h0;
        11'd1  : number = 16'h0;
        11'd2  : number = 16'h0;
        11'd3  : number = 16'h0;
        11'd4  : number = 16'h0;
        11'd5  : number = 16'h0;
        11'd6  : number = 16'h0;
        11'd7  : number = 16'h0;
        11'd8  : number = 16'h0;
        11'd9  : number = 16'h1FF8;
        11'd10 : number = 16'h1FF8;
        11'd11 : number = 16'h0;
        11'd12 : number = 16'h0;
        11'd13 : number = 16'h0;
        11'd14 : number = 16'h0;
        11'd15 : number = 16'h0;
        11'd16 : number = 16'h0;
        11'd17 : number = 16'h0;
        11'd18 : number = 16'h0;
        11'd19 : number = 16'h0;
        default : number = 16'h0;
        endcase
    end
    endcase
endfunction

endmodule
