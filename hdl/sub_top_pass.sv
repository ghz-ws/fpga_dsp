module sub_top_pass #(parameter width=16)(
    input clk,rst,
    input signed [width-1:0]din,
    output signed [width-1:0]dout1,dout2,dout3,dout4,
    input dsm_in,
    output dsm_out,
    output [3:0]gpio
    );
    assign gpio=0;
    assign dsm_out=0;
    assign dout1=din;
    assign dout2=din;
    assign dout3=din;
    assign dout4=din;
endmodule