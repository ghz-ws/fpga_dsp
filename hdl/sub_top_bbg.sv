module sub_top_bbg(
    input clk,rst,
    input signed [15:0]din1,din2,
    output signed [15:0]dout1,dout2,
    output [8:1]pmod
    );
    
	logic pat_sync,syb_clk,data_clk,data_out;
    logic signed [15:0]i,q,i_rc_out,q_rc_out;
    logic cke,den;
    assign pmod[8:5]=0;
    
    parameter tap_len_rc=41;
    parameter [tap_len_rc-1:0][15:0]tap_rc='{0,-320,-723,-1170,-1607,-1966,-2169,-2135,-1794,-1091,0,1474,3289,5365,7592,9833,11942,13770,15184,16078,16384,16078,15184,13770,11942,9833,7592,5365,3289,1474,0,-1091,-1794,-2135,-2169,-1966,-1607,-1170,-723,-320,0};
    parameter tap_len_intp1=31;
    parameter [tap_len_intp1-1:0][15:0]tap_intp1='{-111,-127,-155,-171,-136,0,284,753,1417,2255,3212,4205,5131,5887,6381,6553,6381,5887,5131,4205,3212,2255,1417,753,284,0,-136,-171,-155,-127,-111};
    
    data_gen data_gen(
        .clk(clk),
        .rst(rst),
        .freq(1),//5M/(freq+1) [Mbps]
        .pn(3),//prbs bit length. 0(PN3),1(PN4),2(PN7),3(PN9),4(PN10),5(PN15)
        .syb(2),//bits per symbol. 0(BPSK),1(QPSK),2(16QAM),3(64QAM)
        .i(i),
        .q(q),
        .cke(cke),
        .den(den),
        .pat_sync(pmod[1]),
        .syb_clk(pmod[2]),
        .data_out(pmod[3]),
        .data_clk(pmod[4])
        );
   
    fir_rc #(.tap_len(tap_len_rc)) i_rc(    //rc filter
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .den(den),
        .din(i),
        .dout(i_rc_out),
        .tap(tap_rc)
        );
    fir_rc #(.tap_len(tap_len_rc)) q_rc(
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .den(den),
        .din(q),
        .dout(q_rc_out),
        .tap(tap_rc)
        );
        
    poly_intp #(.tap_len(tap_len_intp1),.rate(8),.m_rate(1)) i_intp1( //interpolator
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .din(i_rc_out),
        .dout(dout1),
        .cke_out(),
        .tap(tap_intp1)
        );
    poly_intp #(.tap_len(tap_len_intp1),.rate(8),.m_rate(1)) q_intp1(
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .din(q_rc_out),
        .dout(dout2),
        .cke_out(),
        .tap(tap_intp1)
        );
endmodule
