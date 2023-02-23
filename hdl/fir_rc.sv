module fir_rc #(parameter tap_len=1)(
    input clk,rst,cke,den,
    input signed [15:0]din,
    output signed [15:0]dout,
    input signed [tap_len-1:0][15:0]tap
    );
    
    logic signed [4:0][15:0]sr;
    logic [3:0]cnt;
    always_ff@(posedge clk)begin
        if(rst)begin
            sr<=0;
            cnt<=0;
        end else begin
            if(cke)begin
                if(cnt==9)begin
                    cnt<=0;
                end else begin
                    cnt<=cnt+1;
                end
            end
            if(den)begin
                sr<={sr[3:0],din};
            end 
        end
    end
    
    logic signed [31:0]temp;
    assign temp=$signed(sr[0])*$signed(tap[cnt])+$signed(sr[1])*$signed(tap[cnt+10])+$signed(sr[2])*$signed(tap[cnt+20])+$signed(sr[3])*$signed(tap[cnt+30])+((cnt==0)?($signed(sr[4])*$signed(tap[cnt+40])):0);
    assign dout=$signed(temp)>>>15;
endmodule