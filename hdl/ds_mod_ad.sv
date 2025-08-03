module ds_mod_ad(
    input clk,rst,cke,
    input din,
    output dac_drive,pdm_out,cke_out,
    output signed [15:0]dout
    );
    //double latch to suppress glitch
    logic [1:0]input_latch;
    always_ff@(posedge clk)begin
        if(rst)begin
            input_latch<=0;
        end else begin
            input_latch<={input_latch[0],din};
        end
    end
    
    //D-FF for delta-sigma feedback
    logic dff;
    assign dac_drive=dff;
    assign pdm_out=!dac_drive;
    always_ff@(posedge clk)begin
        if(rst)begin
            dff<=0;
        end else begin
            if(cke)begin
                dff<=input_latch[1];
            end
        end
    end
    
    //cic decimation filter
    logic signed [15:0]filter_in,filter_out1,filter_out2;
    logic cke1,cke2;
    assign filter_in=(pdm_out)?30000:-30000;
    cic_deci #(.rate(2),.len(4),.width(16),.width_ex(4)) cic_1st(.clk(clk),.rst(rst),.cke(cke),.din(filter_in),.dout(filter_out1),.cke_out(cke1));
    cic_deci #(.rate(2),.len(4),.width(16),.width_ex(4)) cic_2nd(.clk(clk),.rst(rst),.cke(cke1),.din(filter_out1),.dout(filter_out2),.cke_out(cke2));
    cic_deci #(.rate(2),.len(4),.width(16),.width_ex(4)) cic_3rd(.clk(clk),.rst(rst),.cke(cke2),.din(filter_out2),.dout(dout),.cke_out(cke_out));
endmodule
