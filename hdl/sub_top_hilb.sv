module sub_top_hilb(
    input clk,rst,
    input signed [15:0]din1,din2,
    output signed [15:0]dout1,dout2,
    output [8:1]pmod
    );
    
    assign pmod=0;
    parameter tap_len_deci=21;
    parameter tap_len_intp=21;
    parameter [tap_len_deci-1:0][15:0]tap_deci='{-158,-233,-337,-295,173,1324,3218,5623,8032,9823,10485,9823,8032,5623,3218,1324,173,-295,-337,-233,-158}; //fc=0.08
    parameter [tap_len_intp-1:0][15:0]tap_intp='{-158,-233,-337,-295,173,1324,3218,5623,8032,9823,10485,9823,8032,5623,3218,1324,173,-295,-337,-233,-158}; //fc=0.08
    
    parameter tap_len_hilb=31;
    parameter m_len=(tap_len_hilb+4)/4;
    parameter [m_len-1:0][15:0]tap_hilb='{41721,13907,8344,5960,4635,3792,3209,2781};  //right side is [0]
    
    logic cke_out;
    logic signed [15:0]deci2hilb,re2intp,im2intp;
    poly_deci #(.tap_len(tap_len_deci),.rate(5)) deci(
        .clk(clk),
        .rst(rst),
        .cke(1'b1),
        .din(din1),
        .dout(deci2hilb),
        .cke_out(cke_out),
        .tap(tap_deci)
        );
    
    fir_hilb #(.tap_len(tap_len_hilb),.m_len(m_len))hilb(
        .clk(clk),
        .rst(rst),
        .cke(cke_out),
        .din(deci2hilb),
        .re(re2intp),
        .im(im2intp),
        .tap(tap_hilb)
        );
        
    poly_intp #(.tap_len(tap_len_intp),.rate(5),.m_rate(1)) intp_re(
        .clk(clk),
        .rst(rst),
        .cke(cke_out),
        .din(re2intp),
        .dout(dout1),
        .cke_out(),
        .tap(tap_intp)
        );
        
    poly_intp #(.tap_len(tap_len_intp),.rate(5),.m_rate(1)) intp_im(
        .clk(clk),
        .rst(rst),
        .cke(cke_out),
        .din(im2intp),
        .dout(dout2),
        .cke_out(),
        .tap(tap_intp)
        );
    
endmodule
