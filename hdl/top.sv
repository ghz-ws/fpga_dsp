module top(
    input mclk, ext_rst,    //12MHz gclk(L17) is mclk, btn0(A18) is ext_rst
    output ld1,ld2,ld0_r,ld0_g,ld0_b,   //on board leds
    input uart_rx,  //J17
    output uart_tx, //J18
    input btn1, //B18
    input [9:0]adc_in,
    output [9:0]dac1_data,dac2_data,
    output adc_clk,dac1_clk,dac2_clk,
    input dsm_in,
    output dsm_out,
    output [3:0]gpio
    );
    logic locked,clk,rst;
    assign rst=!locked;
    assign uart_tx=1;
    
    //disable on board LEDs
    assign ld1=0;
    assign ld2=0;
    assign ld0_r=1;
    assign ld0_g=1;
    assign ld0_b=1;
    
    //io latch. signed-unsigned conversion, bit width change
    logic signed [9:0]adc_latch,dac1_latch,dac2_latch,dac3_latch,dac4_latch;
    logic signed [9:0]dac1,dac2,dac3,dac4;
    always@(posedge clk)begin
        if(rst)begin
            adc_latch<=0;
            dac1_latch<=0;
            dac2_latch<=0;
            dac3_latch<=0;
            dac4_latch<=0;
        end else begin
            adc_latch<=$signed(adc_in);
            dac1_latch<=$unsigned(dac1+(1<<<9));
            dac2_latch<=$unsigned(dac2+(1<<<9));
            dac3_latch<=$unsigned(dac3+(1<<<9));
            dac4_latch<=$unsigned(dac4+(1<<<9));
        end
    end
    assign dac1_data=(clk)?dac1_latch:dac2_latch;
    assign dac2_data=(clk)?dac3_latch:dac4_latch;
    
    clk_wiz_0 mmcm(
        .clk_out1(clk), //main clk
        .clk_out2(adc_clk),    //adc clk
        .clk_out3(dac1_clk),    //dac1 clk
        .clk_out4(dac2_clk),    //dac2 clk
        .reset(ext_rst),
        .locked(locked),
        .clk_in1(mclk)  //clk in
    );
        
    sub_top_hilb #(.width(10)) sub_top(
        .clk(clk),
        .rst(rst),
        .din(adc_latch),
        .dout1(dac1),
        .dout2(dac2),
        .dout3(dac3),
        .dout4(dac4),
        .dsm_in(dsm_in),
        .dsm_out(dsm_out),
        .gpio(gpio)
    );
endmodule
