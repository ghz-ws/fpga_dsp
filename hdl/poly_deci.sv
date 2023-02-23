module poly_deci #(parameter rate=1,parameter tap_len=1,parameter m_len=(tap_len+rate-1)/rate)(
    input clk,rst,cke,
    input signed [15:0]din,
    output signed [15:0]dout,
    output logic cke_out,
    input signed [tap_len-1:0][15:0]tap
    );
    
    //decimator
    logic [$clog2(rate):0]div;
    logic signed [tap_len-2:0][15:0]sr;
    logic signed [m_len-1:0][31:0]temp; //multiplier
    logic signed [31:0]out_reg,accum;
    always_ff@(posedge clk)begin
        if(rst)begin
            div<=0;
            cke_out<=0;
            sr<=0;
            accum<=0;
        end else begin
            if(cke)begin
                sr<={sr[tap_len-3:0],din};
                if(div==0)begin
                    cke_out<=1;
                    div<=rate-1;
                    out_reg<=accum+$signed(temp[m_len-1]);
                    accum<=0;
                end else begin
                    cke_out<=0;
                    div<=div-1;
                    accum<=accum+$signed(temp[m_len-1]);
                end
            end else begin
                cke_out<=0;
            end
        end
    end
    
    integer i;
    always_comb begin
        temp[0]=$signed(din)*$signed(tap[div]);
        temp[m_len-1]=$signed(temp[m_len-2])+$signed(sr[m_len-1])*((((m_len-1)*rate+div)<=(tap_len-1))?($signed(tap[(m_len-1)*rate+div])):0);
        for(i=1;i<m_len-1;i=i+1)begin
            temp[i]=$signed(temp[i-1])+$signed(sr[i*rate-1])*$signed(tap[i*rate+div]);
        end
    end
    assign dout=out_reg>>>16;
endmodule
