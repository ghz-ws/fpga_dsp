module top(
    input ext_rst,mclk,
    input [9:0]adc1,adc2,
    output logic [9:0]dac1,dac2,
    output dac1_clk,dac2_clk,adc1_clk,adc2_clk,
    output [8:1]pmod,
    output [2:0]led
    );
    
    logic locked,clk,rst;
    assign rst=!locked;
    assign led=3'b111;
    
    //in/out double latch. signed-unsigned change, bit width change
    logic signed [15:0]s_adc1,s_adc2,s_dac1,s_dac2;
    logic [19:0]dl;    //input double latch
    always_ff@(posedge clk)begin
        if(rst)begin
            dl<=0;
            s_adc1<=0;
            s_adc2<=0;
            dac1<=0;
            dac2<=0;
        end else begin
            dl<={adc1,adc2};
            s_adc1<=($signed(dl[19:10]))<<<6;
            s_adc2<=($signed(dl[9:0]))<<<6;
            dac1<=$unsigned((s_dac1>>>6)+(1<<9));
            dac2<=$unsigned((s_dac2>>>6)+(1<<9));
        end
    end
    
    clk_wiz_0 mmcm(
        .clk_out1(clk),
        .clk_out2(adc1_clk),
        .clk_out3(adc2_clk),
        .clk_out4(dac1_clk),
        .clk_out5(dac2_clk),
        .reset(ext_rst),
        .locked(locked),
        .clk_in1(mclk)
        );
        
    sub_top_cic sub_top(
        .clk(clk),
        .rst(rst),
        .din1(s_adc1),
        .dout1(s_dac1),
        .din2(s_adc2),
        .dout2(s_dac2),
        .pmod(pmod)
        );
endmodule
