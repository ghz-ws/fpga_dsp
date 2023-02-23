module cic_deci #(parameter rate=1,parameter len=1,parameter width=1)(
    input clk,rst,cke,
    input signed [15:0]din,
    output signed [15:0]dout,
    output logic cke_out
    );
    
    integer i,j,k;
    logic signed [len-1:0][width+15:0]integ;
    logic signed [len-1:0][width+15:0]dif;
    logic signed [len-1:0][width+15:0]in;
    logic signed [width+15:0]dif_out;
    
    //input integrator
    always_ff@(posedge clk)begin
        if(rst)begin
            integ<=0;
        end else begin
            if(cke)begin
                integ[0]<=din+$signed(integ[0]);
                for(i=1;i<len;i=i+1)begin
                    integ[i]<=$signed(integ[i-1])+$signed(integ[i]);
                end
            end
        end
    end
    
    //down sampler
    logic [$clog2(rate):0]div;
    always_ff@(posedge clk)begin
        if(rst)begin
            div<=0;
            cke_out<=0;
        end else begin
            if(cke)begin
                if(div==rate-1)begin
                    cke_out<=1;
                    div<=0;
                end else begin
                    cke_out<=0;
                    div<=div+1;
                end
            end else begin
                cke_out<=0;
            end
        end
    end
    
    //output differentiator
    always_comb begin
        in[0]=$signed(integ[len-1]);
        for(k=0;k<len-1;k=k+1)begin
            in[k+1]=$signed(in[k])-$signed(dif[k]);
        end
    end
    always_ff@(posedge clk)begin
        if(rst)begin
            dif<=0;
            dif_out<=0;
        end else begin
            if(cke_out)begin
                dif_out<=$signed(in[len-1])-$signed(dif[len-1]);
                for(j=0;j<len;j=j+1)begin
                    dif[j]<=$signed(in[j]);
                end
            end
        end
    end

    assign dout=dif_out>>>width;
endmodule
