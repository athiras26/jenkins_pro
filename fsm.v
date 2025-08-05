//---------------------------------------------------------------------------------------------------
// Description : To design a overlapping sequence detector using Moore machine , which detects 11011
//---------------------------------------------------------------------------------------------------
module fsm (
// clk and reset are  set as the input     
    input  wire   clk,  //clk= 100Mhz
    input  wire   rstn, // active low reset
    input  wire   seq,  //depending on seq , next state is chosen
//detector will be high ,when 11011 is detected
    output reg    detector    
     );
//-----------------------------------------
// parameter based state encoding
//-----------------------------------------
   localparam S0 = 3'b000 ; //start
   localparam S1 = 3'b001 ; //got 1
   localparam S2 = 3'b010 ; //got 11
   localparam S3 = 3'b011 ; //got 110
   localparam S4 = 3'b100 ; //got 1101
   localparam S5 = 3'b101 ; //got 11011
//------------------------------------------------------------
//Internal registers to show the present state and next state
//------------------------------------------------------------
   reg  [2:0]  present_state;
   reg  [2:0]  next_state;
//---------------------------------------------------------------------------------
//                         STATE TRANSITIONS
//  When rstn = 0, the FSM initializes to state S0
//  When rstn = 1, the FSM transitions based on current state
//---------------------------------------------------------------------------------
   always @(posedge clk or negedge rstn) begin
      if(!rstn)begin
         present_state <= S0;
      end else begin
         present_state <= next_state;
      end  
   end
//------------------------------------------------------------------------------------
//                NEXT STATE LOGIC
//Combinational logic for Next State transitions based on current state 
//-------------------------------------------------------------------------------------  
   always @(*) begin
      case(present_state)
        S0 : begin
         next_state = seq ? S1 : S0 ;
        end
        S1 : begin
         next_state = seq ? S2 : S0 ;
        end
        S2 : begin
         next_state = seq ? S2 : S3 ;
        end
        S3 : begin
         next_state = seq ? S4 : S0 ;
        end
        S4 : begin
         next_state = seq ? S5 : S0 ;
        end
        S5 : begin
         next_state = seq ? S0 : S3 ;
        end
        default : begin
         next_state = S0;
        end
      endcase
   end
//----------------------------------------------------------------------
//                OUTPUT LOGIC
//   out is set to 1 when the FSM is in S5 ( sequence 11011 is detected)
//   out is cleared to 0 on reset or in all other cases
//-----------------------------------------------------------------------
   always @(posedge clk or negedge rstn) begin
      if (!rstn) begin
         detector <= 1'b0;
      end else if (present_state == S5) begin
         detector <= 1'b1;
      end else begin
         detector <= 1'b0;
      end           
   end

endmodule