module parity_Check #(parameter IN_DATA_WIDTH = 8)
(
     input wire                        CLK, //clock signal
	 input wire                        RST, //Asynchronous active low reset signal 
	 input wire [IN_DATA_WIDTH-1:0] P_DATA, //parallel input data 
	 input wire                    PAR_TYP, // parity type 
	 input wire                sampled_bit, //sampled bit
	 input wire                 par_chk_en, //parity check enable
	 input wire [5:0]            edge_cnt, // edge counter 
     input wire [5:0]            Prescale, // prescale
	 output reg                    par_err //parity bit error flag 
	
);


reg parity_bit ; // parity bit -- reference


/********************* parity bit calculation ***************************/
always @(*)
  begin
     case(PAR_TYP)
         1'b0 :  begin                 
	             parity_bit <= ~^P_DATA  ;     // Even Parity
	             end
         1'b1 :  begin
	             parity_bit <= ^P_DATA ;     // Odd Parity
	             end		
     endcase       	 
 end 
 
 
 /***************** parity error calculation *****************************/
always@(posedge CLK , negedge RST)
begin 
     if(!RST)
         par_err <=  1'b0 ;
	 else if(par_chk_en && (edge_cnt == ((Prescale >> 1) + 6'b10)))
	     par_err <= parity_bit ^ sampled_bit ; 
end 

endmodule 