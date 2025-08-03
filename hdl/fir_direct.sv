module fir_direct #(parameter tap_len=1, parameter width=16)(
    input clk,rst,cke,
    input signed [width-1:0]din,
    output signed [width-1:0]dout,
    input signed [tap_len-1:0][width-1:0]tap
    );
    
    logic signed [tap_len-2:0][width-1:0]sr;
    always_ff@(posedge clk)begin
        if(rst)begin
            sr<=0;
        end else begin
            if(cke)begin
                sr<={sr[tap_len-3:0],din};
            end 
        end
    end
    
    logic signed [tap_len-1:0][(width*2-1):0]temp;
    integer i;
    always_comb begin
        temp[0]=din*$signed(tap[0]);
        for(i=0;i<tap_len;i=i+1)begin
            temp[i+1]=$signed(temp[i])+$signed(sr[i])*$signed(tap[i+1]);
        end
    end
    
    assign dout=$signed(temp[tap_len-1])>>>width;        
endmodule