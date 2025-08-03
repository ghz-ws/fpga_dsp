module sub_top_fir #(parameter width=16)(
    input clk,rst,
    input signed [width-1:0]din,
    output signed [width-1:0]dout1,dout2,dout3,dout4,
    input dsm_in,
    output dsm_out,
    output [3:0]gpio
    );
    assign gpio=0;
    assign dsm_out=0;
    
    localparam tap_len=21;
    localparam [tap_len-1:0][width-1:0]tap='{0,-2,-6,-11,-12,0,32,83,141,187,204,187,141,83,32,0,-12,-11,-6,-2,0};    //fc=0.1
    
    fir_direct #(.tap_len(tap_len),.width(width))fir(
        .clk(clk),
        .rst(rst),
        .cke(1'b1),
        .din(din),
        .dout(dout1),
        .tap(tap)
    );
        
    assign dout2=din;
    assign dout3=din;
    assign dout4=din;
endmodule