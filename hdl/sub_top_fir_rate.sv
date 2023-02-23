module sub_top_fir_rate(
    input clk,rst,
    input signed [15:0]din1,din2,
    output signed [15:0]dout1,dout2,
    output [8:1]pmod
    );
    
    assign pmod=0;
    parameter tap_len=21;
    parameter tap_len_deci=21;
    parameter tap_len_intp=21;
    parameter [tap_len-1:0][15:0]tap='{0,-139,-416,-764,-813,0,2091,5359,9048,11985,13107,11985,9048,5359,2091,0,-813,-764,-416,-139,0};//fc=0.1
    parameter [tap_len_deci-1:0][15:0]tap_deci='{-158,-233,-337,-295,173,1324,3218,5623,8032,9823,10485,9823,8032,5623,3218,1324,173,-295,-337,-233,-158}; //fc=0.08
    parameter [tap_len_intp-1:0][15:0]tap_intp='{-158,-233,-337,-295,173,1324,3218,5623,8032,9823,10485,9823,8032,5623,3218,1324,173,-295,-337,-233,-158}; //fc=0.08
    
    logic cke_out;
    logic signed [15:0]deci2fir,fir2intp;
    poly_deci #(.tap_len(tap_len_deci),.rate(5)) deci(
        .clk(clk),
        .rst(rst),
        .cke(1'b1),
        .din(din1),
        .dout(deci2fir),
        .cke_out(cke_out),
        .tap(tap_deci)
        );
    
    fir_direct #(.tap_len(tap_len))fir(
        .clk(clk),
        .rst(rst),
        .cke(cke_out),
        .din(deci2fir),
        .dout(fir2intp),
        .tap(tap_deci)
        );
        
    poly_intp #(.tap_len(tap_len_intp),.rate(5),.m_rate(1)) intp(
        .clk(clk),
        .rst(rst),
        .cke(cke_out),
        .din(fir2intp),
        .dout(dout1),
        .cke_out(),
        .tap(tap_intp)
        );
    
endmodule
