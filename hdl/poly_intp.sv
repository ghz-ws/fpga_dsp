module poly_intp #(parameter rate=1,parameter m_rate=1,parameter tap_len=1,parameter m_len=(tap_len+rate-1)/rate)(
    input clk,rst,cke,
    input signed [15:0]din,
    output signed [15:0]dout,
    output logic cke_out,
    input signed [tap_len-1:0][15:0]tap
    );
    
    //interpolator
    logic [$clog2(m_rate):0]div;
    logic signed [m_len-1:0][15:0]sr;
    logic [$clog2(rate):0]cnt;
    always_ff@(posedge clk)begin
        if(rst)begin
            sr<=0;
            cnt<=0;
            div<=0;
        end else begin
            if(cke)begin
                sr<={sr[m_len-2:0],din};
                cnt<=0;
                div<=0;
                cke_out<=1;
            end else begin
                if(div==m_rate-1)begin
                    cke_out<=1;
                    div<=0;
                    if(cnt==rate-1)begin
                        cnt<=0;
                    end else begin
                        cnt<=cnt+1;
                    end
                end else begin
                    cke_out<=0;
                    div<=div+1;
                end
            end
        end
    end
    
    integer i;
    logic signed [m_len-1:0][31:0]temp;
    always_comb begin
        temp[0]=$signed(sr[0])*$signed(tap[cnt]);
        temp[m_len-1]=$signed(temp[m_len-2])+$signed(sr[m_len-1])*((((m_len-1)*rate+cnt)<=(tap_len-1))?($signed(tap[(m_len-1)*rate+cnt])):0);
        for(i=1;i<m_len-1;i=i+1)begin
            temp[i]=$signed(temp[i-1])+$signed(sr[i])*$signed(tap[i*rate+cnt]);
        end
    end
    assign dout=$signed(temp[m_len-1])>>>(15-$clog2(rate+1)+2);
endmodule
