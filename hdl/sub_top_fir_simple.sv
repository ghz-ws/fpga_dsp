module sub_top_fir_simple(
    input clk,rst,
    input signed [15:0]din1,din2,
    output signed [15:0]dout1,dout2,
    output [8:1]pmod
    );
    
    assign pmod=0;
    parameter tap_len=21;
    parameter [tap_len-1:0][15:0]tap='{0,-139,-416,-764,-813,0,2091,5359,9048,11985,13107,11985,9048,5359,2091,0,-813,-764,-416,-139,0};    //fc=0.1
    
    fir_direct #(.tap_len(tap_len))fir(
        .clk(clk),
        .rst(rst),
        .cke(1'b1),
        .din(din1),
        .dout(dout1),
        .tap(tap)
        );
    
    assign dout2=din2;
endmodule
