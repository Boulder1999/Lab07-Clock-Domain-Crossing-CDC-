`ifdef RTL
	`timescale 1ns/1ps
	`include "CDC.v"
	`define CYCLE_TIME_clk1 36.7
	`define CYCLE_TIME_clk2 6.8
	`define CYCLE_TIME_clk3 2.6
`endif
`ifdef GATE
	`timescale 1ns/1ps
	`include "CDC_SYN.v"
	`define CYCLE_TIME_clk1 36.7
	`define CYCLE_TIME_clk2 6.8
	`define CYCLE_TIME_clk3 2.6
`endif
module PATTERN(
	//Output Port
	clk1,
    clk2,
    clk3,
	rst_n,
	in_valid1,
	in_valid2,
	user1,
	user2,

    //Input Port
    out_valid1,
    out_valid2,
	equal,
	exceed,
	winner
); 
//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
output reg			clk1, clk2, clk3, rst_n;
output reg			in_valid1, in_valid2;
output reg [3:0]	user1, user2;

input 				out_valid1, out_valid2;
input 				equal, exceed, winner;

// ===============================================================
// Parameter & Integer Declaration
// ===============================================================
real CYCLE_clk1 = `CYCLE_TIME_clk1;
real CYCLE_clk2 = `CYCLE_TIME_clk2;
real CYCLE_clk3 = `CYCLE_TIME_clk3;
//================================================================
// Wire & Reg Declaration
//================================================================
integer i, j, patcount_in, patcount_ans, total_cycles, pat_filein, pat_fileans;
parameter PATNUM = 1000;

//================================================================
// Clock
//================================================================
initial clk1 = 0;
always #(CYCLE_clk1/2.0) clk1 = ~clk1;
initial clk2 = 0;
always #(CYCLE_clk2/2.0) clk2 = ~clk2;
initial clk3 = 0;
always #(CYCLE_clk3/2.0) clk3 = ~clk3;

reg [3:0] user1_reg [4:0], user2_reg[4:0];


reg [6:0] user1_eq [1:0], user1_ex[1:0], user2_eq[1:0], user2_ex[1:0];
reg [1:0] winner_reg;
always@(negedge clk2 or negedge rst_n)begin
    if(patcount_in>0 & patcount_ans<patcount_in & patcount_ans<PATNUM)begin
        if(patcount_ans<PATNUM)begin
            $fscanf(pat_fileans, "%d %d %d %d ",         user1_eq[0], user1_ex[0], user1_eq[1], user1_ex[1]);
            $fscanf(pat_fileans, "%d %d %d %d %2b \n",   user2_eq[0], user2_ex[0], user2_eq[1], user2_ex[1], winner_reg);
            $fscanf(pat_fileans, "\n");
        end

        wait_outvalid_1;
        for(i=0;i<7;i=i+1)begin
            if(out_valid1!==1)  YOU_FAIL(7);
            if( (equal !== user1_eq[0][6-i]) || (exceed !== user1_ex[0][6-i]) )begin
                $display("wrong at pattern %d, 1st equal/exceed of user1 should be %2d, %2d", patcount_ans, user1_eq[0], user1_ex[0]);
                YOU_FAIL(8);
            end
            @(negedge clk3);
        end

        wait_outvalid_1;
        for(i=0;i<7;i=i+1)begin
            if(out_valid1!==1)  YOU_FAIL(7);
            if( (equal !== user1_eq[1][6-i]) || (exceed !== user1_ex[1][6-i]) )begin
                $display("wrong at pattern %d, 2nd equal/exceed of user1 should be %2d, %2d", patcount_ans, user1_eq[1], user1_ex[1]);
                YOU_FAIL(8);
            end
            @(negedge clk3);
        end

        wait_outvalid_1;
        for(i=0;i<7;i=i+1)begin
            if(out_valid1!==1)  YOU_FAIL(7);
            if( (equal !== user2_eq[0][6-i]) || (exceed !== user2_ex[0][6-i]) )begin
                $display("wrong at pattern %d, 1st equal/exceed of user2 should be %2d, %2d", patcount_ans, user2_eq[0], user2_ex[0]);
                YOU_FAIL(8);
            end
            @(negedge clk3);
        end

        wait_outvalid_1;
        for(i=0;i<7;i=i+1)begin
            if(out_valid1!==1)  YOU_FAIL(7);
            if( (equal !== user2_eq[1][6-i]) || (exceed !== user2_ex[1][6-i]) )begin
                $display("wrong at pattern %d, 2nd equal/exceed of user2 should be %2d, %2d", patcount_ans, user2_eq[1], user2_ex[1]);
                YOU_FAIL(8);
            end
            @(negedge clk3);
        end
        
        wait_outvalid_2;
        if(winner_reg==0)begin
            if(winner!==0)begin $display("wrong at pattern %d, winner should be 0", patcount_ans); YOU_FAIL(8);  end
            @(negedge clk3);
            if(out_valid2===1) YOU_FAIL(1);
        end
        else begin
            if(winner!==winner_reg[1])begin $display("wrong at pattern %d, winner should be %2b", patcount_ans, winner_reg); YOU_FAIL(8);  end
            @(negedge clk3);
            if(out_valid2===0) YOU_FAIL(2);
            
            if(winner!==winner_reg[0])begin $display("wrong at pattern %d, winner should be %2b", patcount_ans, winner_reg); YOU_FAIL(8);  end
            @(negedge clk3);
            if(out_valid2===1) YOU_FAIL(2);
        end
        
        $display(" PASS PATTERN NO.%4d, accumulated cycle %d", patcount_ans, total_cycles);
        if(patcount_ans+1==PATNUM)begin
            YOU_PASS_task;
  	        $finish;
        end
        
        patcount_ans = patcount_ans + 1;
        
    end else
        patcount_ans = 0;
end

//================================================================
// Initial
//================================================================
initial begin
    
    rst_n = 1;

    in_valid1 = 1'd0;   in_valid2 = 1'd0;
    user1 = 5'dx;       user2 = 5'dx;
  	force clk1 = 0; force clk2 = 0; force clk3 = 0;
  	reset_task;
  	total_cycles = 0;
    @(negedge clk2);

    pat_filein = $fopen("../00_TESTBED/input.txt", "r");
    pat_fileans = $fopen("../00_TESTBED/answer.txt", "r");

    delay_task;
    @(negedge clk2);
    
    patcount_in = 0;
    while(patcount_in<PATNUM)begin
        $fscanf(pat_filein, "%d %d %d %d %d \n", user1_reg[0], user1_reg[1], user1_reg[2], user1_reg[3], user1_reg[4]);
        $fscanf(pat_filein, "%d %d %d %d %d \n", user2_reg[0], user2_reg[1], user2_reg[2], user2_reg[3], user2_reg[4]);
        $fscanf(pat_filein, "\n");

        patcount_in = patcount_in + 1;
        
        in_valid1 = 1'd1;
        for(j=0;j<5;j=j+1)begin
            user1 = user1_reg[j];
            @(negedge clk1);
        end
        in_valid1 = 1'd0;
        user1 = 5'dx;

        in_valid2 = 1'd1;
        for(j=0;j<5;j=j+1)begin
            user2 = user2_reg[j];
            @(negedge clk1);
        end
        in_valid2 = 1'd0;
        user2 = 5'dx;
    end
    
end


//================================================================
// env task
//================================================================
task reset_task ; begin
	#(0.5); rst_n = 0;

	#(60.0);
	//if (out_valid1!==0 || out_valid2!==0) YOU_FAIL(3);
	
	#(1.0); rst_n = 1 ;
	#(3.0); release clk1; release clk2; release clk3;
end endtask

task YOU_FAIL;
input [4:0] fail_specnum;
integer n;
begin
    if(fail_specnum==6)     $display("latency over.\n");
    else if(fail_specnum==3) $display ("outvalid should be low\n");
	else if(fail_specnum==2)  $display ("outvalid should be 2 cycle\n");
    else if(fail_specnum==1)  $display ("outvalid should be 1 cycle\n");
    else if(fail_specnum==7)  $display ("outvalid should be 7 cycle\n");
    $finish;
end endtask

task wait_outvalid_1;
integer cycles;
begin
	cycles = -1;
	while(out_valid1 !== 1)begin
		cycles = cycles + 1;
        if(cycles == 1000) YOU_FAIL(6);
    
      @(negedge clk3);
	end
	total_cycles = total_cycles + (cycles+1); // +1, since the 1st out count for 1 cycle.
end endtask

task wait_outvalid_2;
integer cycles;
begin
	cycles = -1;
	while(out_valid2 !== 1)begin
		cycles = cycles + 1;
        if(cycles == 1000) YOU_FAIL(6);
    
      @(negedge clk3);
	end
	total_cycles = total_cycles + (cycles+1); // +1, since the 1st out count for 1 cycle.
end endtask

task delay_task ;
integer delay_gap;
begin
	  delay_gap = $urandom_range(1, 4);
	  
    repeat(delay_gap)@(negedge clk1);
end endtask


task YOU_PASS_task;begin
repeat(5) @(negedge clk3);
$display ("----------------------------------------------------------------------------------------------------------------------");
$display ("                                                  Congratulations!                						            ");
$display ("                                           You have passed all patterns!          						            ");
$display ("----------------------------------------------------------------------------------------------------------------------");
$finish;	
end endtask

endmodule

