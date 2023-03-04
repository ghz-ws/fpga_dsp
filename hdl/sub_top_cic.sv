module sub_top_cic(
    input clk,rst,
    input signed [15:0]din1,din2,
    output signed [15:0]dout1,dout2,
    output [8:1]pmod
    );
    
    assign pmod=0;
    logic cke_out;
    logic signed [15:0]deci2fir,fir2intp;
    cic_deci #(.rate(10),.len(4),.width(14)) deci(
        .clk(clk),
        .rst(rst),
        .cke(1'b1),
        .din(din1),
        .dout(dout1),
        .cke_out(cke_out)
        );
        
    assign dout2=din2;
    
endmodule
