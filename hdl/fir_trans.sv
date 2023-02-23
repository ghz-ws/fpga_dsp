module fir_trans #(parameter tap_len=1)(
    input clk,rst,cke,
    input signed [15:0]din,
    output signed [15:0]dout,
    input signed [tap_len-1:0][15:0]tap
    );
    
    logic signed [tap_len-2:0][31:0]sr;
    integer i;
    always_ff@(posedge clk)begin
        if(rst)begin
            sr<=0;
        end else begin
            if(cke)begin
                sr[tap_len-2]<=din*$signed(tap[tap_len-1]);
                for(i=tap_len-3;i>=0;i=i-1)begin
                    sr[i]<=din*$signed(tap[i+1])+$signed(sr[i+1]);
                end
            end
        end
    end
    
    assign dout=(din*$signed(tap[0])+$signed(sr[0]))>>>16;
endmodule