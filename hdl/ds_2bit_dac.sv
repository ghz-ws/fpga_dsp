module ds_2bit_dac(
    input clk,rst,cke,
    input signed [15:0]din,
    output logic [1:0]dout
    );
    logic signed [15:0]din_reg,dac; //data input latch,internal dac
    logic signed [16:0]sigma,delta; //sigma register, delta out
    assign delta=din_reg-dac;       //calc delta
    always_comb begin               //calc dac value and dout value depends on sigma regster value
        if(sigma>10922) begin
            dac=32767;
            dout=3;
        end else if(10922>=sigma&&sigma>0) begin
            dac=10922;
            dout=2;
        end else if(0>=sigma&&sigma>-10922) begin
            dac=-10922;
            dout=1;
        end else begin
            dac=-32768;
            dout=0;
        end
    end
    always_ff@(posedge clk)begin    //sigma register drive
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
