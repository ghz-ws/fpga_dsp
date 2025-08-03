module sub_top_hilb #(parameter width=16)(
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
    localparam [tap_len_deci-1:0][width-1:0]tap_deci='{-2,-3,-5,-4,2,20,50,87,125,153,163,153,125,87,50,20,2,-4,-5,-3,-2}; //fc=0.08
    localparam [tap_len_intp-1:0][width-1:0]tap_intp='{-2,-3,-5,-4,2,20,50,87,125,153,163,153,125,87,50,20,2,-4,-5,-3,-2}; //fc=0.08
    
    localparam tap_len_hilb=31;
    localparam m_len=(tap_len_hilb+4)/4;
    localparam [m_len-1:0][width-1:0]tap_hilb='{651,217,130,93,72,59,50,43};  //right side is [0]
    
    logic cke_out;
    logic signed [15:0]deci2hilb, re2intp, im2intp;
    poly_deci #(.tap_len(tap_len_deci),.rate(5),.width(width)) deci(
        .clk(clk),
        .rst(rst),
        .cke(1'b1),
        .din(din),
        .dout(deci2hilb),
        .cke_out(cke_out),
        .tap(tap_deci)
    );
    fir_hilb #(.tap_len(tap_len_hilb),.m_len(m_len),.width(width)) hilb(
        .clk(clk),
        .rst(rst),
        .cke(cke_out),
        .din(deci2hilb),
        .re(re2intp),
        .im(im2intp),
        .tap(tap_deci)
    );
        
    poly_intp #(.tap_len(tap_len_intp),.rate(5),.m_rate(1),.width(width)) intp_re(
        .clk(clk),
        .rst(rst),
        .cke(cke_out),
        .din(re2intp),
        .dout(dout1),
        .cke_out(),
        .tap(tap_intp)
    );
    poly_intp #(.tap_len(tap_len_intp),.rate(5),.m_rate(1),.width(width)) intp_im(
        .clk(clk),
        .rst(rst),
        .cke(cke_out),
        .din(im2intp),
        .dout(dout2),
        .cke_out(),
        .tap(tap_intp)
    );
    assign dout3=din;
    assign dout4=din;
endmodule