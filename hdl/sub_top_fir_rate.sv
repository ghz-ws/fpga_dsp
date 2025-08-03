module sub_top_fir_rate #(parameter width=16)(
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
    localparam tap_len_deci=21;
    localparam tap_len_intp=21;
    localparam [tap_len-1:0][width-1:0]tap='{0,-2,-6,-11,-12,0,32,83,141,187,204,187,141,83,32,0,-12,-11,-6,-2,0};//fc=0.1
    localparam [tap_len_deci-1:0][width-1:0]tap_deci='{-2,-3,-5,-4,2,20,50,87,125,153,163,153,125,87,50,20,2,-4,-5,-3,-2}; //fc=0.08
    localparam [tap_len_intp-1:0][width-1:0]tap_intp='{-2,-3,-5,-4,2,20,50,87,125,153,163,153,125,87,50,20,2,-4,-5,-3,-2}; //fc=0.08
    
    logic cke_out1,cke_out2;
    logic signed [15:0]deci2fir,fir2intp;
    poly_deci #(.tap_len(tap_len_deci),.rate(5),.width(width)) deci(
        .clk(clk),
        .rst(rst),
        .cke(1'b1),
        .din(din),
        .dout(deci2fir),
        .cke_out(cke_out1),
        .tap(tap_deci)
    );
    fir_direct #(.tap_len(tap_len),.width(width)) fir(
        .clk(clk),
        .rst(rst),
        .cke(cke_out1),
        .din(deci2fir),
        .dout(fir2intp),
        .tap(tap_deci)
    );  
    poly_intp #(.tap_len(tap_len_intp),.rate(5),.m_rate(1),.width(width)) intp(
        .clk(clk),
        .rst(rst),
        .cke(cke_out1),
        .din(fir2intp),
        .dout(dout1),
        .cke_out(),
        .tap(tap_intp)
    );  
    assign dout2=din;
    assign dout3=din;
    assign dout4=din;
endmodule