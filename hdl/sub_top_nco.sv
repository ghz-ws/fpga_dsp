module sub_top_nco(
    input clk,rst,
    input signed [15:0]din1,din2,
    output signed [15:0]dout1,dout2,
    output [8:1]pmod
    );
    
    assign pmod=0;
    nco nco1(
        .clk(clk),
        .rst(rst),
        .freq(268435456/50*1),
        .out(dout1)
        );
        
    nco nco2(
        .clk(clk),
        .rst(rst),
        .freq(268435456/50*2),
        .out(dout2)
        );
endmodule