module sub_top_under(
    input clk,rst,
    input signed [15:0]din1,din2,
    output logic signed [15:0]dout1,dout2,
    output [8:1]pmod
    );
    
    assign pmod=0;
    logic cke_out;
    
    //under sampler
    parameter div_ratio=100;
    logic [$clog2(div_ratio):0]div;
    always_ff@(posedge clk)begin
        if(rst)begin
            div<=0;
        end else begin
            if(div==div_ratio)begin
                div<=0;
                dout1<=din1;
            end else begin
                div<=div+1;
            end
        end
    end
        
    assign dout2=din2;
    
endmodule
