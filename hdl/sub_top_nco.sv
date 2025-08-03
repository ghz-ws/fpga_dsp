module sub_top_nco #(parameter width=16)(
    input clk,rst,
    input signed [width-1:0]din,
    output signed [width-1:0]dout1,dout2,dout3,dout4,
    input dsm_in,
    output dsm_out,
    output [3:0]gpio
    );
    assign gpio=0;
    assign dsm_out=0;
    
    nco #(.width(10)) nco1(
        .clk(clk),
        .rst(rst),
        .freq(268435456/50*1),
        .out(dout1)
    );
    nco #(.width(10)) nco2(
        .clk(clk),
        .rst(rst),
        .freq(268435456/50*2),
        .out(dout2)
    );
    nco #(.width(10)) nco3(
        .clk(clk),
        .rst(rst),
        .freq(268435456/50*3),
        .out(dout3)
    );
    nco #(.width(10)) nco4(
        .clk(clk),
        .rst(rst),
        .freq(268435456/50*4),
        .out(dout4)
    );
endmodule