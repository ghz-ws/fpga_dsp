`timescale 1ns / 1ps
module tb_top();
    bit mclk,ext_rst, uart_rx, btn1;
    logic ld1,ld2,ld0_r,ld0_g,ld0_b, uart_tx;
    logic dsm_in, dsm_out;
    logic [3:0]gpio=0;
    logic [9:0]adc_in, dac1_data, dac2_data;
    logic adc_clk,dac1_clk,dac2_clk;
    
    always #42ns mclk<=!mclk;
    
    initial begin
        @(posedge dut.locked);
        #5us
        $finish;
    end
    
    //external delta-sigma module for delta-sigma ADC test
    wire signed [9:0]din=adc_in; //delta-sigma input
    wire ds_clk=dut.clk;
    wire ds_cke=dut.sub_top.cke;//dut.cke;
    wire ds_rst=dut.rst;
    logic dac_drive,comp_out;
    logic signed [10:0]sigma,delta,comp_in; //sigma register, delta out
    logic signed [9:0]dac;                 //dac value
    assign dac=(dac_drive)?511:-512;    //if dac_drive>0, dac=511 
    assign delta=din-dac;                   //calc delta
    assign comp_in=sigma+delta;             //comparator in. 1 clk forward to sigma reg. out
    assign comp_out=!comp_in[10];           //if sigma>0 comp_out=1
    always_ff@(posedge ds_clk)begin
        if(ds_rst)begin
            sigma<=0;
        end else begin
            if(ds_cke)begin
                sigma<=sigma+delta;
            end
        end
    end
    assign dsm_in=comp_out;
    assign dac_drive=dsm_out;
    
    top dut(.*);
    nco_sim nco(.out(adc_in));
endmodule
