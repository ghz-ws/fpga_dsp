module sub_top_cic #(parameter width=16)(
    input clk,rst,
    input signed [width-1:0]din,
    output signed [width-1:0]dout1,dout2,dout3,dout4,
    input dsm_in,
    output dsm_out,
    output [3:0]gpio
    );
    assign gpio=0;
    assign dsm_out=0;
    
    cic_deci #(.rate(10),.len(4),.width(width),.width_ex(14)) deci(
        .clk(clk),
        .rst(rst),
        .cke(1'b1),
        .din(din),
        .dout(dout1),
        .cke_out()
    );
    assign dout2=din;
    assign dout3=din;
    assign dout4=din;
endmodule