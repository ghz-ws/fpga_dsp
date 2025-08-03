module sub_top_bbg #(parameter width=16)(
    input clk,rst,
    input signed [width-1:0]din,
    output signed [width-1:0]dout1,dout2,dout3,dout4,
    input dsm_in,
    output dsm_out,
    output [3:0]gpio
    );
    assign gpio[3:1]=0;
    assign dsm_out=0;
    
    logic signed [width-1:0]i_rc_in,q_rc_in,i_rc_out,q_rc_out,carrier;
    logic cke,den;
    localparam tap_len_rc=41;
    localparam [tap_len_rc-1:0][width-1:0]tap_rc='{0,-5,-11,-18,-25,-30,-33,-33,-28,-17,0,23,51,83,118,153,186,215,237,251,256,251,237,215,186,153,118,83,51,23,0,-17,-28,-33,-33,-30,-25,-18,-11,-5,0};
    localparam tap_len_intp=31;
    localparam [tap_len_intp-1:0][width-1:0]tap_intp='{-1,-1,-2,-2,-2,0,4,11,22,35,50,65,80,91,99,102,99,91,80,65,50,35,22,11,4,0,-2,-2,-2,-1,-1};  //fc=0.05
    
    data_gen #(.width(width)) data_gen(
        .clk(clk),
        .rst(rst),
        .freq(1),//5M/(freq+1) [Mbps]
        .pn(3),//prbs bit length. 0(PN3),1(PN4),2(PN7),3(PN9),4(PN10),5(PN15)
        .syb(2),//bits per symbol. 0(BPSK),1(QPSK),2(16QAM),3(64QAM)
        .i_out(i_rc_in),
        .q_out(q_rc_in),
        .cke(cke),
        .den(den),
        .pat_sync(),
        .syb_clk(gpio[0]),
        .data_out(),
        .data_clk()
    );
    fir_rc #(.tap_len(tap_len_rc), .width(width)) i_rc( //rc filter
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .den(den),
        .din(i_rc_in),
        .dout(i_rc_out),
        .tap(tap_rc)
    );
    fir_rc #(.tap_len(tap_len_rc), .width(width)) q_rc(
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .den(den),
        .din(q_rc_in),
        .dout(q_rc_out),
        .tap(tap_rc)
    );
    poly_intp #(.tap_len(tap_len_intp),.rate(8),.m_rate(1),.width(width)) i_intp( //interpolator
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .din(i_rc_out),
        .dout(dout1),
        .cke_out(),
        .tap(tap_intp)
    );
    poly_intp #(.tap_len(tap_len_intp),.rate(8),.m_rate(1),.width(width)) q_intp(
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .din(q_rc_out),
        .dout(dout2),
        .cke_out(),
        .tap(tap_intp)
    );
    nco #(.width(10)) nco(
        .clk(clk),
        .rst(rst),
        .freq(268435456/50*10),  //10MHz carrier
        .out(carrier)
    );
    wire [width*2-1:0]temp=carrier*dout1;
    assign dout3=temp>>>(width-1);
    assign dout4=carrier;
endmodule