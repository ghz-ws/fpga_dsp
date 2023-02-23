module sub_top_pass(
    input clk,rst,
    input signed [15:0]din1,din2,
    output signed [15:0]dout1,dout2,
    output [8:1]pmod
    );
    
    assign pmod=0;
    assign dout1=din1;
    assign dout2=din2;
endmodule