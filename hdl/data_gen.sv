module data_gen(
    input clk,rst,
	input [9:0]freq,       //1-1000, 1M/(freq+1) [Mbps]
	input [2:0]pn,         //prbs bit length. 0(3),1(4),2(7),3(9),4(10),5(15)
	input [1:0]syb,        //bits per symbol. 0(1),1(2),2(4),3(8)
	output logic signed [15:0]i,q,
	output logic pat_sync,syb_clk,data_out,cke,data_clk,den
    );
    
    logic [2:0]syb_len;     //symbol length sel
	always_comb begin
	   case(syb)
	       0:syb_len=0;
	       1:syb_len=1;
	       2:syb_len=3;
	       3:syb_len=7;
	       default:syb_len=0;
	   endcase
	end
	
    logic [3:0]len;     //PN length sel
    always_comb begin
        case(pn)
            0:len=3;
            1:len=4;
            2:len=7;
            3:len=9;
            4:len=10;
            5:len=15;
            default:len=3;
        endcase
    end
    
    //lfsr tri. and cke counter
    logic [9:0]cnt2;
	logic [3:0]cnt1,cnt3;
	logic [2:0]cnt4;
	logic lfsr_trig,cke_pre;
    always_ff@(posedge clk)begin
        if(rst)begin
            cnt1<=0;
            cnt2<=0;
            cnt3<=0;
            cnt4<=0;
            lfsr_trig<=0;
            cke<=0;
            cke_pre<=0;
        end else begin
            cke<=cke_pre;//1 cycle latency for cke
            if(cnt2==freq)begin
                cnt2<=0;
                if(cnt4==syb_len)begin
                    cke_pre<=1;
                    cnt4<=0;
                end else begin
                    cke_pre<=0;
                    cnt4<=cnt4+1;
                end
                if(cnt3==9)begin
                    cnt3<=0;
                    lfsr_trig<=1;
                end else begin
                    lfsr_trig<=0;
                    cnt3<=cnt3+1;
                end
            end else begin
                cnt2<=cnt2+1;
                cke_pre<=0;
                lfsr_trig<=0;
            end
        end
    end
    
    assign data_clk=(cnt3<=4)?1:0;  //data clk
    
    //prbs gen
	logic [14:0]prbs_lfsr,div;
	logic seed;
	assign data_out=prbs_lfsr[len-1];
	always_ff@(posedge clk)begin
	   if(rst)begin
	       prbs_lfsr<=0;
	       div<=0;
	       pat_sync<=0;
	   end else begin
	       if(lfsr_trig)begin
	           prbs_lfsr<={prbs_lfsr[13:0],!seed};
	           if(div==6&&len==3)begin
	               pat_sync<=1;
	               div<=0;
	           end else if(div==14&&len==4)begin
	               pat_sync<=1;
	               div<=0;
	           end else if(div==126&&len==7)begin
	               pat_sync<=1;
	               div<=0;
	           end else if(div==510&&len==9)begin
	               pat_sync<=1;
	               div<=0;
	           end else if(div==1022&&len==10)begin
	               pat_sync<=1;
	               div<=0;
	           end else if(div==32766&&len==15)begin
	               pat_sync<=1;
	               div<=0;
	           end else begin
	               pat_sync<=0;
	               div<=div+1;
               end
           end
	   end
	end
	
	always_comb begin  //TAP position sel
	   case(len)
	       3:seed=prbs_lfsr[2]^prbs_lfsr[1];
	       4:seed=prbs_lfsr[3]^prbs_lfsr[2];
	       7:seed=prbs_lfsr[6]^prbs_lfsr[5];
	       9:seed=prbs_lfsr[8]^prbs_lfsr[4];
	       10:seed=prbs_lfsr[9]^prbs_lfsr[6];
	       15:seed=prbs_lfsr[14]^prbs_lfsr[13];
	       default:seed=1;
	   endcase
	end
	
	//deserializer
	logic [3:0]div2;
	logic [5:0]local_buf;
	always_ff@(posedge clk)begin
        if(rst)begin
            i<=0;       //i data. zero padding
            q<=0;       //q data. zero padding
            local_buf<=0;   //local buffer for multi level
            div2<=0;        //divider for multi level
            den<=0;     //data enable for poly phase filter
            syb_clk<=0; //symbol clk
        end else begin
            if(lfsr_trig)begin
                local_buf<={local_buf,data_out};
                if(syb==0&&div2==syb_len)begin
                    i<=(local_buf[0])?32767:-32768;
	                q<=0;
                    syb_clk<=1;
                    div2<=0;
                    den<=1;
                end else if(syb==1&&div2==syb_len)begin
                    i<=(local_buf[0])?32767:-32768;
	                q<=(local_buf[1])?32767:-32768;
	                syb_clk<=1;
	                div2<=0;
	                den<=1;
                end else if(syb==2&&div2==syb_len)begin
                    i<=quad(local_buf[1:0]);
	                q<=quad(local_buf[3:2]);
	                syb_clk<=1;
	                div2<=0;
	                den<=1;
	            end else if(syb==3&&div2==syb_len)begin
                    i<=oct(local_buf[2:0]);
	                q<=oct(local_buf[5:3]);
	                syb_clk<=1;
	                div2<=0;
	                den<=1;
                end else begin
                    syb_clk<=0;
                    div2<=div2+1;
                    den<=0;
                end
            end else begin
                i<=0;
                q<=0;
                den<=0;
            end
        end
    end
    
    function [15:0]quad;    //quad leveler
        input [1:0]din;
        begin
            case(din)
                0:quad=-32768;
                1:quad=-10922;
                2:quad=10922;
                3:quad=32767;
                default:quad=0;
            endcase
        end
    endfunction
    
    function [15:0]oct;     //oct leveler
        input [2:0]din;
        begin
            case(din)
                0:oct=-32768;
                1:oct=-23405;
                2:oct=-14043;
                3:oct=-4681;
                4:oct=4681;
                5:oct=14043;
                6:oct=23405;
                7:oct=32767;
                default:oct=0;
            endcase
        end
    endfunction
endmodule
