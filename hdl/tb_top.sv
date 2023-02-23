`timescale 1ns / 1ps

module tb_top();
    bit mclk,ext_rst;
    logic [9:0]adc1,adc2,dac1,dac2;
    logic dac1_clk,dac2_clk,adc1_clk,adc2_clk;
    logic [8:1]pmod;
    logic [2:0]led;
    logic signed [9:0]out;
    
    always #42ns mclk<=!mclk;
    assign adc1=out;
    assign adc2=out;
    
    initial begin
        @(posedge dut.locked);
        #100us
        $finish;
    end
    
    top dut(.*);
    nco_sim nco(.*);
endmodule
