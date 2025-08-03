module sub_top_ds_dac #(parameter width=16)(
    input clk,rst,
    input signed [width-1:0]din,
    output signed [width-1:0]dout1,dout2,dout3,dout4,
    input dsm_in,
    output dsm_out,
    output [3:0]gpio
    );
    assign gpio=0;
    assign dsm_out=0;
    
    localparam div_ratio=100;        //50M/100=500k delta-sigma clk
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
    logic signed [15:0]nco_out;
    logic ds_out;   //delta-sigma modulator output. PDM signal
    logic [1:0]ds_out_2bit;   //delta-sigma modulator output. 2bit PDM signal
    nco #(.width(16)) nco(
        .clk(clk),
        .rst(rst),
        .freq(268435456/50000*1),   //nco set 1kHz
        .out(nco_out)
    );
    ds_1st_dac ds_dac_1st(
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .din(nco_out),
        .dout(ds_out)
    );
    ds_2bit_dac ds_dac_2bit(
        .clk(clk),
        .rst(rst),
        .cke(cke),
        .din(nco_out),
        .dout(ds_out_2bit)
    );

    assign dout1=$signed(nco_out>>>(16-width));
    assign dout2=(ds_out)?$signed(32767>>>(16-width)):$signed(-32768>>>(16-width));
    assign dout3=(ds_out_2bit==3)?$signed(32767>>>(16-width)):(ds_out_2bit==2)?$signed(10922>>>(16-width)):(ds_out_2bit==1)?$signed(-10922>>>(16-width)):$signed(-32768>>>(16-width)); //2bit pdm signal
    assign dout4=din;
endmodule