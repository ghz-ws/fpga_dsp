`timescale 1ns / 1ps

module nco_sim( //use only testbench
	output logic signed [9:0]out
    );
    
    bit clk;
    always #5ns clk<=!clk;
    
    logic [27:0]freq=268435456/100*1;

    //phase accumulator
	logic [27:0]accum=0;
	always_ff@(posedge clk)begin
	   accum<=accum+freq;
	end
	
	//sin table
	logic signed [15:0]table_out,sin_out;
	assign sin_out=(accum[27]==1)?0-table_out:table_out;   //0-179 / 180-359
	assign out=sin_out>>>6;
	always_comb begin
	   case(accum[26:22])
	        0:table_out=0;
	        1:table_out=3210;
            2:table_out=6389;
            3:table_out=9507;
            4:table_out=12533;
            5:table_out=15439;
            6:table_out=18196;
            7:table_out=20778;
            8:table_out=23160;
            9:table_out=25319;
            10:table_out=27235;
            11:table_out=28889;
            12:table_out=30265;
            13:table_out=31349;
            14:table_out=32132;
            15:table_out=32606;
            16:table_out=32766;
            17:table_out=32611;
            18:table_out=32143;
            19:table_out=31365;
            20:table_out=30285;
            21:table_out=28914;
            22:table_out=27264;
            23:table_out=25353;
            24:table_out=23197;
            25:table_out=20818;
            26:table_out=18239;
            27:table_out=15485;
            28:table_out=12581;
            29:table_out=9557;
            30:table_out=6440;
            31:table_out=3262;
            default:table_out=0;
	   endcase
	end
	
endmodule
