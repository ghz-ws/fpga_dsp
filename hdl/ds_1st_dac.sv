module ds_1st_dac(
    input clk,rst,cke,
    input signed [15:0]din,
    output dout
    );
    logic signed [15:0]din_reg,dac;         //data input latch, internal dac
    logic signed [16:0]sigma,delta;         //sigma register, delta out
    assign dac=(sigma[16])?-32768:32767;    //if sigma>0, dac=32767 
    assign delta=din_reg-dac;               //calc delta
    assign dout=!sigma[16];                 //if sigma>0 dout=1
    always_ff@(posedge clk)begin            //sigam register drive
        if(rst)begin
            din_reg<=0;
            sigma<=0;
        end else begin
            if(cke)begin
                din_reg<=din;
                sigma<=sigma+delta;
            end
        end
    end
endmodule
