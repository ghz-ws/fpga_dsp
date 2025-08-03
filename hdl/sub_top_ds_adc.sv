module sub_top_ds_adc #(parameter width=16)(
    input clk,rst,
    input signed [width-1:0]din,
    output signed [width-1:0]dout1,dout2,dout3,dout4,
    input dsm_in,
    output dsm_out,
    output [3:0]gpio
    );
    assign gpio=0;
    
    //clk div for delta-sigma D-FF
    localparam div_ratio=50;        //50M/100=500k delta-sigma clk
    logic [$clog2(div_ratio+1):0]div;
    logic cke;
    always_ff@(posedge clk)begin
        if(rst)begin
            div<=0;
            cke<=0;
        end else begin
            if(div==div_ratio-1)begin
                div<=0;
                cke<=1;
            end else begin
                div<=div+1;
                cke<=0;
            end
        end
    end
    //delta-sigma adc
    logic pdm;
    logic signed [15:0]adc_out;
    ds_mod_ad ds_adc(
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .din(dsm_in),    //comparator signal
        .dac_drive(dsm_out),    //dac signal
        .pdm_out(pdm),
        .cke_out(),
        .dout(adc_out)
    );
    assign dout1=$signed(adc_out>>>(16-width));
    assign dout2=(pdm)?$signed(32767>>>(16-width)):$signed(-32768>>>(16-width));
    assign dout3=din;
    assign dout4=din;
endmodule