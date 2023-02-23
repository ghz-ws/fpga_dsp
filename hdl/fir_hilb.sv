module fir_hilb #(parameter tap_len=1,parameter m_len=(tap_len+4)/4)(
    input clk,rst,cke,
    input signed [15:0]din,
    output signed [15:0]re,im,
    input signed [m_len-1:0][15:0]tap
    );
    
    logic signed [tap_len-2:0][15:0]sr;
    always_ff@(posedge clk)begin
        if(rst)begin
            sr<=0;
        end else begin
            if(cke)begin
                sr<={sr[tap_len-3:0],din};
            end 
        end
    end
    
    logic signed [m_len-1:0][31:0]temp;
    integer i;
    always_comb begin
        temp[0]=($signed(sr[tap_len-2])-din)*$signed(tap[0]);
        for(i=0;i<m_len-1;i=i+1)begin
            temp[i+1]=$signed(temp[i])+($signed(sr[tap_len-2-2*(i+1)])-$signed(sr[2*i+1]))*$signed(tap[i+1]);
        end
    end
    
    assign im=$signed(temp[m_len-1])>>>16;
    assign re=$signed(sr[(m_len-1)*2]);        
endmodule