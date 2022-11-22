`include "synchronizer.v"
`include "syn_XOR.v"
module CDC(
	//Input Port
	clk1,
    clk2,
    clk3,
	rst_n,
	in_valid1,
	in_valid2,
	user1,
	user2,

    //Output Port
    out_valid1,
    out_valid2,
	equal,
	exceed,
	winner
); 
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input 		clk1, clk2, clk3, rst_n;
input 		in_valid1, in_valid2;
input [3:0]	user1, user2;

output reg	out_valid1, out_valid2;
output reg	equal, exceed, winner;
//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------
//----clk1----
reg [5:0] cards[1:10];
integer i;
reg [6:0] equal1;
reg [6:0] equal2;
reg [6:0] exceed1;
reg [6:0] exceed_result;
reg [6:0] get_cards1;
reg [6:0] get_cards2;
reg [6:0] get_cards1_temp;
reg [6:0] get_cards2_temp;
reg [6:0] get_cards1_a;
reg [6:0] get_cards2_a;
reg [5:0] cnt_out1;
reg [5:0] cnt_out2;
reg [6:0] cnt_out3;
reg [4:0] cnt_epoch;
reg clk1flag;
wire clk3flag;
reg clk1flag_a;
wire clk3flag_a;
reg clk1flag_e9;
wire clk3flag_e9;
reg [6:0] equal_clk3[0:1];
reg [6:0] exceed_clk3[0:1];
reg [6:0] get_cards1_clk3;
reg [6:0] get_cards2_clk3;
reg [1:0] cnt_clk3;
reg [1:0] cnt_clk3_a;
reg [1:0] cnt_clk3_e9;
reg [6:0] cnt_temp;
reg [1:0] win;
reg clk1flag_win;
wire clk3flag_win;
reg clk1flag_win_;
wire clk3flag_win_;
reg [4:0] cnt_win;
reg [5:0] cnt_for_win;
//----clk2----

//----clk3----

//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
//----clk1----

//----clk2----

//----clk3----

//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
//============================================
//   clk1 domain
//============================================


always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		cnt_temp<=0;
	end 
	else if(in_valid1 || in_valid2) begin
		if(cnt_temp==50) cnt_temp<=1;
		else cnt_temp<=cnt_temp+1;		
	end
	else cnt_temp<=0;
end

always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		cnt_epoch<=0;
	end 
	else if(in_valid1 || in_valid2) begin
		if(cnt_epoch == 10) cnt_epoch<=1;
		else cnt_epoch <= cnt_epoch +1;		
	end
	
end

always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		cards[1]<=16;
		for(i=2;i<11;i=i+1) cards[i]<=4;
	end 
	else if(cnt_temp==49) begin
		cards[1]<=16;
		for(i=2;i<11;i=i+1) cards[i]<=4;
	end
	else if(in_valid1 ) begin
				case(user1 )
				4'd1:cards[1]<=cards[1]-1;
				4'd2:cards[2]<=cards[2]-1;
				4'd3:cards[3]<=cards[3]-1;
				4'd4:cards[4]<=cards[4]-1;
				4'd5:cards[5]<=cards[5]-1;
				4'd6:cards[6]<=cards[6]-1;
				4'd7:cards[7]<=cards[7]-1;
				4'd8:cards[8]<=cards[8]-1;
				4'd9:cards[9]<=cards[9]-1;
				4'd10:cards[10]<=cards[10]-1;
				4'd11:cards[1]<=cards[1]-1;
				4'd12:cards[1]<=cards[1]-1;
				4'd13:cards[1]<=cards[1]-1;
				default:begin
					for(i=1;i<14;i=i+1)
						cards[i]<=cards[i];
				end
				endcase
	end
	else if(in_valid2) begin
				case(user2 )
				4'd1:cards[1]<=cards[1]-1;
				4'd2:cards[2]<=cards[2]-1;
				4'd3:cards[3]<=cards[3]-1;
				4'd4:cards[4]<=cards[4]-1;
				4'd5:cards[5]<=cards[5]-1;
				4'd6:cards[6]<=cards[6]-1;
				4'd7:cards[7]<=cards[7]-1;
				4'd8:cards[8]<=cards[8]-1;
				4'd9:cards[9]<=cards[9]-1;
				4'd10:cards[10]<=cards[10]-1;
				4'd11:cards[1]<=cards[1]-1;
				4'd12:cards[1]<=cards[1]-1;
				4'd13:cards[1]<=cards[1]-1;
				default:begin
					for(i=1;i<14;i=i+1)
						cards[i]<=cards[i];
				end
				endcase
	end
end

always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		get_cards1<=0;
	end 
	else if( in_valid1 ) begin
			case(user1 )
			4'd1:get_cards1<=get_cards1+1;
			4'd2:get_cards1<=get_cards1+2;
			4'd3:get_cards1<=get_cards1+3;
			4'd4:get_cards1<=get_cards1+4;
			4'd5:get_cards1<=get_cards1+5;
			4'd6:get_cards1<=get_cards1+6;
			4'd7:get_cards1<=get_cards1+7;
			4'd8:get_cards1<=get_cards1+8;
			4'd9:get_cards1<=get_cards1+9;
			4'd10:get_cards1<=get_cards1+10;
			4'd11:get_cards1<=get_cards1+1;
			4'd12:get_cards1<=get_cards1+1;
			4'd13:get_cards1<=get_cards1+1;
			default:get_cards1<=get_cards1;
			endcase
	end
	else if(cnt_epoch == 7) begin
		get_cards1<=0;
	end
end
always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		get_cards1_temp<=52;
	end 
	else if(cnt_epoch == 6) begin
		get_cards1_temp<=get_cards1;
	end
end
always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		get_cards2_temp<=52;
	end 
	else if(cnt_epoch == 10) begin
		get_cards2_temp<=get_cards2;
	end
end

always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		get_cards2<=0;
	end 
	else if( in_valid2 ) begin
			case(user2 )
			4'd1:get_cards2<=get_cards2+1;
			4'd2:get_cards2<=get_cards2+2;
			4'd3:get_cards2<=get_cards2+3;
			4'd4:get_cards2<=get_cards2+4;
			4'd5:get_cards2<=get_cards2+5;
			4'd6:get_cards2<=get_cards2+6;
			4'd7:get_cards2<=get_cards2+7;
			4'd8:get_cards2<=get_cards2+8;
			4'd9:get_cards2<=get_cards2+9;
			4'd10:get_cards2<=get_cards2+10;
			4'd11:get_cards2<=get_cards2+1;
			4'd12:get_cards2<=get_cards2+1;
			4'd13:get_cards2<=get_cards2+1;
			default:get_cards2<=get_cards2;
			endcase
	end
	else if( cnt_epoch == 1) begin
		get_cards2<=0;
	end
end


always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		equal1<=0;
	end 
	else if(cnt_temp==50) begin
		equal1<=0;
	end
	else if(cnt_epoch==3 || cnt_epoch == 4 ) begin
		if(21>get_cards1) begin
			if(11 > get_cards1) equal1 <= 0;
			else equal1<=(cards[21-get_cards1]*100/(52-cnt_temp));
		end
		else equal1<=0;
	end
	else if(cnt_epoch==8 || cnt_epoch == 9 )begin
		if(21>get_cards2) begin
			if(11 > get_cards2) equal1 <= 0;
			else equal1<=(cards[21-get_cards2]*100/(52-cnt_temp));
		end
		else equal1<=0;
	end
	else equal1<=0;
end

always@(*) begin
	if(!rst_n) begin
		exceed1=0;
	end 
	else if(cnt_temp==50) begin
		exceed1=0;
	end
	else if(cnt_epoch==3 || cnt_epoch == 4  ) begin
		if(12 > get_cards1) exceed1 = 0; // 21-getcards>10
		else begin
			case(21-get_cards1)
			0:exceed1=100;
			1:exceed1=(cards[2]+cards[3]+cards[4]+cards[5]+cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			2:exceed1=(cards[3]+cards[4]+cards[5]+cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			3:exceed1=(cards[4]+cards[5]+cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			4:exceed1=(cards[5]+cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			5:exceed1=(cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			6:exceed1=(cards[7]+cards[8]+cards[9]+cards[10]);
			7:exceed1=(cards[8]+cards[9]+cards[10]);
			8:exceed1=(cards[9]+cards[10]);
			9:exceed1=(cards[10]);
			default:exceed1=100;
			endcase
		end
	end
	else if(cnt_epoch==8 || cnt_epoch == 9  ) begin
		if(12>get_cards2) exceed1=0;
		else begin
			case(21-get_cards2)
			0:exceed1=100;
			1:exceed1=(cards[2]+cards[3]+cards[4]+cards[5]+cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			2:exceed1=(cards[3]+cards[4]+cards[5]+cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			3:exceed1=(cards[4]+cards[5]+cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			4:exceed1=(cards[5]+cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			5:exceed1=(cards[6]+cards[7]+cards[8]+cards[9]+cards[10]);
			6:exceed1=(cards[7]+cards[8]+cards[9]+cards[10]);
			7:exceed1=(cards[8]+cards[9]+cards[10]);
			8:exceed1=(cards[9]+cards[10]);
			9:exceed1=(cards[10]);
			default:exceed1=100;
			endcase
		end
	end
	else exceed1=0;
end

always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		exceed_result<=0;
	end
	else if(cnt_epoch==3 || cnt_epoch == 4 ) begin
		if(21 > get_cards1 ) begin
			exceed_result<=exceed1*100/(52-cnt_temp);
		end
		else exceed_result<=100;
	end
	else if(cnt_epoch==8 || cnt_epoch == 9 )begin
		if( 21 > get_cards2 ) begin
			exceed_result<=exceed1*100/(52-cnt_temp);
		end
		else exceed_result<=100;
	end
	
end
always@(*) begin
	if(!rst_n) begin
		clk1flag=0;
	end 
	else if(cnt_epoch==4 ||cnt_epoch==3  || cnt_epoch == 9 ||cnt_epoch==8 ) begin
		clk1flag=1;
	end
	else clk1flag=0;
end



always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) cnt_clk3<=0;
	 
	else if(clk3flag) 
		if(cnt_clk3==0) cnt_clk3<=cnt_clk3+1;
		else if (cnt_clk3 ==1) cnt_clk3<=0;
end



always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) cnt_out1<=6;
	else if(cnt_clk3 ==1 )  begin
		if(clk3flag) cnt_out1<=0;
		else if(cnt_out1 == 6) cnt_out1<=cnt_out1;
		else cnt_out1<=cnt_out1+1;
	end
	else if(cnt_clk3 ==0 )  begin
		if(clk3flag) cnt_out1<=0;
		else if(cnt_out1 == 6) cnt_out1<=cnt_out1;
		else cnt_out1<=cnt_out1+1;
	end
end

always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) out_valid1<=0;
	else if(cnt_out1 != 6 || clk3flag )  begin
		 out_valid1<=1;
	end
	else out_valid1<=0;
end
always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) begin
		equal<=0;
	end 
	else if(clk3flag==1)
		equal<=equal1[6];
	else if(cnt_out1 < 6 && out_valid1==1) begin
		case(cnt_out1)
		0:equal<=equal1[5];
		1:equal<=equal1[4];
		2:equal<=equal1[3];
		3:equal<=equal1[2];
		4:equal<=equal1[1];
		5:equal<=equal1[0];
		endcase
	end
	else equal<=0;
end

always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) begin
		exceed<=0;
	end 
	else if(clk3flag==1)
		exceed<=exceed_result[6];
	else if(cnt_out1 < 6 && out_valid1==1) begin
		case(cnt_out1)
		0:exceed<=exceed_result[5];
		1:exceed<=exceed_result[4];
		2:exceed<=exceed_result[3];
		3:exceed<=exceed_result[2];
		4:exceed<=exceed_result[1];
		5:exceed<=exceed_result[0];
		endcase
	end
	else exceed<=0;
end
always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n)begin
		win<=0;
	end
	else if(get_cards1_temp ==52 && get_cards2_temp ==52) win<=0;
	else begin
		if(get_cards1_temp > 21 && get_cards2_temp > 21 || get_cards1_temp == get_cards2_temp) win <= 3;
		else if( get_cards1_temp > 21 && get_cards2_temp < 22) win<=2;
		else if( get_cards2_temp > 21 && get_cards1_temp < 22) win<=1;
		else begin
			if(get_cards1_temp > get_cards2_temp) win<=1;
			else win<=2;
		end
	end
end
always@(*) begin
	if(!rst_n) begin
		clk1flag_e9=0;
	end 
	if(in_valid1 || in_valid2) begin
		if(cnt_epoch==9  || cnt_epoch ==10) begin
			clk1flag_e9=1;
		end
		else clk1flag_e9=0;
	end
	else clk1flag_e9=0;
end
always@(*) begin
	if(!rst_n) begin
		clk1flag_win=0;
	end 
	if(in_valid1 || in_valid2) begin
		if(cnt_epoch==1  || cnt_epoch ==2) begin
			clk1flag_win=1;
		end
		else clk1flag_win=0;
	end
	else clk1flag_win=0;
end
always@(*) begin
	if(!rst_n) begin
		clk1flag_win_=0;
	end 
	else if(cnt_epoch==10  || cnt_epoch ==2) begin
			clk1flag_win_=1;
		end
	else clk1flag_win_=0;
	
end
always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) cnt_for_win<=0;
		else if(clk3flag_win_) cnt_for_win<=0;
		else cnt_for_win<=cnt_for_win+1;
end
always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) cnt_win<=6;
		else if(clk3flag_win && clk3flag_win_==0) cnt_win<=0;
		else if(cnt_for_win == 48 && in_valid2 ==0 && in_valid1 == 0) cnt_win<=0;
		else if(cnt_win == 6) cnt_win<=cnt_win;
		else if(clk3flag_win && clk3flag_win_) cnt_win<=cnt_win;
		else cnt_win<=cnt_win+1;
end
/*
always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) cnt_clk3_e9<=0;
	else if(clk3flag_e9 ==1 )  begin
		cnt_clk3_e9<=cnt_clk3_e9+1;
	end
	else if(cnt_clk3_e9 == 2) cnt_clk3_e9<=0;
end

always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) cnt_out3<=0;
	else if(cnt_clk3_e9 ==1 )  begin
		cnt_out3<=cnt_out3+1;
	end
	else if(cnt_clk3_e9 == 2) cnt_out3<=0;
end

always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) out_valid2<=0;
	else if(clk3flag_e9 && in_valid2) out_valid2<=1;
	else if(cnt_clk3_e9 == 1 && cnt_out3 == 0 && in_valid2) begin
		if(get_cards1_temp > 21 && get_cards2 > 21 || get_cards1_temp == get_cards2) out_valid2 <= 0;
		else out_valid2<=1;
	end
	else out_valid2<=0;
end
/*
always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) begin
		winner<=1'b0;
	end
	else if(clk3flag_e9 && in_valid2)
	begin
		if(get_cards1_temp > 21 && get_cards2 > 21 || get_cards1_temp == get_cards2) winner <= 0;
		else if( get_cards1_temp < 22 || get_cards2 < 22 ) winner <= 1;

	end
	else if(cnt_clk3_e9 == 1 && cnt_out3 == 0 && in_valid2) begin
		if(get_cards1_temp > 21 && get_cards2 > 21 || get_cards1_temp == get_cards2) winner<=0;
		else if( get_cards1_temp > 21 && get_cards2 < 22) begin
			winner<=1;
		end
		else if(get_cards2 > 21 && get_cards1_temp < 22) begin
			winner<=0;
		end
		else begin
			if( get_cards1_temp > get_cards2) begin
				winner<=0;
			end
			else begin
				winner<=1;
			end
		end
	end
	//else if(cnt_out3 > 0) winner<=0;
	else winner<=0;
end
*/
always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) out_valid2<=0;
	else if(clk3flag_win_ && (in_valid1 ==0 && in_valid2 == 0)) begin
		if(cnt_for_win > 40) out_valid2<=1;
		else out_valid2<=0;
	end
	else if(clk3flag_win && clk3flag_win_) out_valid2<=0;
	else if(clk3flag_win && win > 0) out_valid2<=1;
	else if(cnt_win==0 && win > 0 ) begin
		if(win == 3) out_valid2<=0;
		else if(win==1 || win==2) out_valid2<=1;
	end
	else out_valid2<=0;
end

always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) winner<=0;
	else if(clk3flag_win && clk3flag_win_) winner<=0;
	else if(clk3flag_win && in_valid1 ==0 && in_valid2 == 0) begin
		if(win == 3) winner<=0;
		else if(win == 1|| win ==2) winner<=1;
	end
	else begin
	 	if( clk3flag_win  )
		begin
			if(win == 3) winner<=0;
			else if(win == 1|| win ==2) winner<=1;
		end
		else if(cnt_win==0) begin
			if(win==1) winner<=0;
			else if(win==2) winner<=1;
		end
		else winner<=0;
	end
end

//---------------------------------------------------------------------
//   syn_XOR
//---------------------------------------------------------------------
syn_XOR u_syn_XOR(.IN(clk1flag),.OUT(clk3flag),.TX_CLK(clk1),.RX_CLK(clk3),.RST_N(rst_n));
syn_XOR u_syn_XOR1(.IN(clk1flag_e9),.OUT(clk3flag_e9),.TX_CLK(clk1),.RX_CLK(clk3),.RST_N(rst_n));
syn_XOR u_syn_XOR2(.IN(clk1flag_win),.OUT(clk3flag_win),.TX_CLK(clk1),.RX_CLK(clk3),.RST_N(rst_n));
syn_XOR u_syn_XOR3(.IN(clk1flag_win_),.OUT(clk3flag_win_),.TX_CLK(clk1),.RX_CLK(clk3),.RST_N(rst_n));
endmodule