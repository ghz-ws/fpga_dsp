module cic_intp #(parameter rate=1,parameter m_rate=1,parameter len=1,parameter width=1)(
    input clk,rst,cke,
    input signed [15:0]din,
    output signed [15:0]dout,
    output logic cke_out
    );
    
    integer i,j,k,l;
    logic signed [len-1:0][width+15:0]integ;
    logic signed [len-1:0][rate-1:0][width+15:0]dif;
    logic signed [len-1:0][width+15:0]in;
    logic signed [width+15:0]dif_out,feed;
    
    //input differentiator
    always_comb begin
        in[0]=din;
        for(k=0;k<len-1;k=k+1)begin
            in[k+1]=$signed(in[k])-$signed(dif[k][rate-1]);
        end
    end
    always_ff@(posedge clk)begin
        if(rst)begin
            dif<=0;
            dif_out<=0;
        end else begin
            if(cke)begin
                dif_out<=$signed(in[len-1])-$signed(dif[len-1][rate-1]);
                for(j=0;j<len;j=j+1)begin
                    dif[j][0]<=$signed(in[j]);
                    for(l=0;l<rate-1;l=l+1)begin
                        dif[j][l+1]<=$signed(dif[j][l]);
                    end
                end
            end
        end
    end
    
    //up sampler
    logic [$clog2(m_rate):0]div;
    always_ff@(posedge clk)begin
        if(rst)begin
            div<=0;
            cke_out<=0;
        end else begin
            if(div==m_rate-1)begin
                cke_out<=1;
                div<=0;
            end else begin
                cke_out<=0;
                div<=div+1;
            end
        end
    end
    always_comb begin
        feed=(cke)?dif_out:0;   //when cke=0, zero padding
    end
    
    //output integrator
    always_ff@(posedge clk)begin
        if(rst)begin
            integ<=0;
        end else begin
            if(cke_out)begin
                integ[0]<=feed+$signed(integ[0]);
                for(i=1;i<len;i=i+1)begin
                    integ[i]<=$signed(integ[i-1])+$signed(integ[i]);
                end
            end
        end
    end
    
    assign dout=$signed(integ[len-1])>>>width;
endmodule
