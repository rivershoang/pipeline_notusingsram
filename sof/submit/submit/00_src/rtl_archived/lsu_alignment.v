////////////////////////////////////
// Doan Dinh Nam      
// 23.11.2024   
// namhero02@gmail.com 
////////////////////////////////////

`include "D:/Verilog_archived/02_CPU/03_FinnRISCV/rtl/cpu_def.vh"

module lsu_alignment (
   // ==== control signal ===== //
   input  wire          clk,
                        rst_n,
                        w_en,
   input  wire [31:0]   w_data,
   output reg  [31:0]   r_data,
   input  wire [15:0]   addr,
   input  wire [2:0]    data_mode,     // b - h - w - bu - hu
   // ==== input signal ==== //
   input  wire [16:0]   SW,            //SW[17] used to reset
   input  wire [3:0]    KEY,
   // ==== output signal ===== //
   output wire [16:0]   LEDR,          //LEDR[17] used to display SW[17]
   output wire [7:0]    LEDG,
   output wire [6:0]    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
   output wire          LCD_EN,
                        LCD_RS,
                        LCD_RW,
   output wire [7:0]    LCD_DATA
); 
   // Breakdown w_data into Bytes
   wire  [7:0] BYTE  [0:3];

   // IN_MEM
   reg   [7:0] KEY_MEM   [0:3];        // 0x7810
   reg   [7:0] SW_MEM    [0:3];        // 0x7800
   
   // OUT_MEM
   reg   [7:0] LCD_MEM   [0:3];        // 0x7030
   reg   [7:0] HEX_MEM_H [0:3];        // 0x7024
   reg   [7:0] HEX_MEM_L [0:3];        // 0x7020
   reg   [7:0] LEDG_MEM  [0:3];        // 0x7010
   reg   [7:0] LEDR_MEM  [0:3];        // 0x7000

   // DMEM
   reg   [7:0] DMEM      [0:2**11-1];   // 0x0000 - 0x07FF

   // Connect w_data to their byte pieces
   assign BYTE[0] = w_data[7:0];
   assign BYTE[1] = w_data[15:8];
   assign BYTE[2] = w_data[23:16];
   assign BYTE[3] = w_data[31:24]; 
   
   // Connect OUT_MEM to their counterparts
   assign LCD_DATA = LCD_MEM[0];
   assign LCD_RW   = LCD_MEM[1][0];
   assign LCD_RS   = LCD_MEM[1][1];
   assign LCD_EN   = LCD_MEM[1][2];

   assign HEX4 = HEX_MEM_H[0][6:0];
   assign HEX5 = HEX_MEM_H[1][6:0];
   assign HEX6 = HEX_MEM_H[2][6:0];
   assign HEX7 = HEX_MEM_H[3][6:0];

   assign HEX0 = HEX_MEM_L[0][6:0];
   assign HEX1 = HEX_MEM_L[1][6:0];
   assign HEX2 = HEX_MEM_L[2][6:0];
   assign HEX3 = HEX_MEM_L[3][6:0];

   assign LEDG = LEDG_MEM[0];

   assign LEDR[7:0]  = LEDR_MEM[0];
   assign LEDR[15:8] = LEDR_MEM[1];
   assign LEDR[16]   = LEDR_MEM[2][0];

   // DMEM_REG_SELECT
   wire  [7:0] DMEM_reg  [0:3];

   // MEM_OUT_SELECT
   reg   [31:0]   MEM_OUT_B,
                  MEM_OUT_H,
                  MEM_OUT_W,
                  MEM_OUT_BU,
                  MEM_OUT_HU;

   // ==== Write with Alighment ==== //               
   always @(posedge clk, negedge rst_n) begin
      if (!rst_n) begin
         KEY_MEM[0] <= 0;
         KEY_MEM[1] <= 0;
         KEY_MEM[2] <= 0;
         KEY_MEM[3] <= 0;
         
         SW_MEM[0] <= 0;
         SW_MEM[1] <= 0;
         SW_MEM[2] <= 0;
         SW_MEM[3] <= 0;
      end
      else begin
         KEY_MEM[0] <= {4'b0, KEY};
         KEY_MEM[1] <= 0;
         KEY_MEM[2] <= 0;
         KEY_MEM[3] <= 0;
      
         SW_MEM[0] <= SW[7:0];
         SW_MEM[1] <= SW[15:8];
         SW_MEM[2] <= {7'b0, SW[16]};
         SW_MEM[3] <= 0;
      end
   end

   always @(posedge clk, negedge rst_n) begin
      if (!rst_n) begin
         LCD_MEM[0] <= 0;
         LCD_MEM[1] <= 0;
         LCD_MEM[2] <= 0;
         LCD_MEM[3] <= 0;

         HEX_MEM_H[0] <= 8'h40;
         HEX_MEM_H[1] <= 8'h40;
         HEX_MEM_H[2] <= 8'h40;
         HEX_MEM_H[3] <= 8'h40;
         HEX_MEM_L[0] <= 8'h40;
         HEX_MEM_L[1] <= 8'h40;
         HEX_MEM_L[2] <= 8'h40;
         HEX_MEM_L[3] <= 8'h40;

         LEDG_MEM[0] <= 0;
         LEDG_MEM[1] <= 0;
         LEDG_MEM[2] <= 0;
         LEDG_MEM[3] <= 0;

         LEDR_MEM[0] <= 0;
         LEDR_MEM[1] <= 0;
         LEDR_MEM[2] <= 0;
         LEDR_MEM[3] <= 0;
      end
      else begin
         if (w_en) begin 
            casez (addr)
               16'b0111_0000_0011_00??:         // 0x7030   (LCD_MEM)
               begin
                  case (data_mode) 
                     `B: begin
                        LCD_MEM[addr[1:0]+0] <= BYTE[0];
                     end     
                     `H: begin
                        LCD_MEM[addr[1:0]+0] <= BYTE[0];
                        LCD_MEM[addr[1:0]+1] <= BYTE[1];
                     end
                     `W: begin
                        LCD_MEM[addr[1:0]+0] <= BYTE[0];
                        LCD_MEM[addr[1:0]+1] <= BYTE[1];
                        LCD_MEM[addr[1:0]+2] <= BYTE[2];
                        LCD_MEM[addr[1:0]+3] <= BYTE[3];
                     end
                  endcase
               end
               16'b0111_0000_0010_01??:         // 0x7024   (HEX_MEM_H)
               begin
                  case (data_mode) 
                     `B: begin
                        HEX_MEM_H[addr[1:0]+0] <= BYTE[0];
                     end     
                     `H: begin
                        HEX_MEM_H[addr[1:0]+0] <= BYTE[0];
                        HEX_MEM_H[addr[1:0]+1] <= BYTE[1];
                     end
                     `W: begin
                        HEX_MEM_H[addr[1:0]+0] <= BYTE[0];
                        HEX_MEM_H[addr[1:0]+1] <= BYTE[1];
                        HEX_MEM_H[addr[1:0]+2] <= BYTE[2];
                        HEX_MEM_H[addr[1:0]+3] <= BYTE[3];
                     end
                  endcase               
               end
               16'b0111_0000_0010_00??:         // 0x7020   (HEX_MEM_L)
               begin
                  case (data_mode) 
                     `B: begin
                        HEX_MEM_L[addr[1:0]+0] <= BYTE[0];
                     end     
                     `H: begin
                        HEX_MEM_L[addr[1:0]+0] <= BYTE[0];
                        HEX_MEM_L[addr[1:0]+1] <= BYTE[1];
                     end
                     `W: begin
                        HEX_MEM_L[addr[1:0]+0] <= BYTE[0];
                        HEX_MEM_L[addr[1:0]+1] <= BYTE[1];
                        HEX_MEM_L[addr[1:0]+2] <= BYTE[2];
                        HEX_MEM_L[addr[1:0]+3] <= BYTE[3];
                     end
                  endcase                    
               end
               16'b0111_0000_0001_00??:         // 0x7010   (LEDG_MEM)
               begin
                  case (data_mode) 
                     `B: begin
                        LEDG_MEM[addr[1:0]+0] <= BYTE[0];
                     end     
                     `H: begin
                        LEDG_MEM[addr[1:0]+0] <= BYTE[0];
                        LEDG_MEM[addr[1:0]+1] <= BYTE[1];
                     end
                     `W: begin
                        LEDG_MEM[addr[1:0]+0] <= BYTE[0];
                        LEDG_MEM[addr[1:0]+1] <= BYTE[1];
                        LEDG_MEM[addr[1:0]+2] <= BYTE[2];
                        LEDG_MEM[addr[1:0]+3] <= BYTE[3];
                     end
                  endcase                    
               end
               16'b0111_0000_0000_00??:         // 0x7000   (LEDR_MEM)
               begin
                  case (data_mode) 
                     `B: begin
                        LEDR_MEM[addr[1:0]+0] <= BYTE[0];
                     end     
                     `H: begin
                        LEDR_MEM[addr[1:0]+0] <= BYTE[0];
                        LEDR_MEM[addr[1:0]+1] <= BYTE[1];
                     end
                     `W: begin
                        LEDR_MEM[addr[1:0]+0] <= BYTE[0];
                        LEDR_MEM[addr[1:0]+1] <= BYTE[1];
                        LEDR_MEM[addr[1:0]+2] <= BYTE[2];
                        LEDR_MEM[addr[1:0]+3] <= BYTE[3];
                     end
                  endcase                    
               end
               16'b0000_0???_????_????:         // 0x0000 - 0x07FFF  (DMEM)
               begin
                  case (data_mode) 
                     `B: begin
                        DMEM[addr[10:0]+0] <= BYTE[0];
                     end     
                     `H: begin
                        DMEM[addr[10:0]+0] <= BYTE[0];
                        DMEM[addr[10:0]+1] <= BYTE[1];
                     end
                     `W: begin
                        DMEM[addr[10:0]+0] <= BYTE[0];
                        DMEM[addr[10:0]+1] <= BYTE[1];
                        DMEM[addr[10:0]+2] <= BYTE[2];
                        DMEM[addr[10:0]+3] <= BYTE[3];
                     end
                  endcase                      
               end
            endcase
         end
      end
   end

   // ==== Read with Alighment ==== //

   assign DMEM_reg[0] = DMEM[{addr[10:2], 2'b0}];
   assign DMEM_reg[1] = DMEM[{addr[10:2], 2'b0}+1];
   assign DMEM_reg[2] = DMEM[{addr[10:2], 2'b0}+2];
   assign DMEM_reg[3] = DMEM[{addr[10:2], 2'b0}+3];

   // MEM_OUT_SELECT
   always @(*) begin
      casez (addr)
         16'b0111_1000_0001_00??:         // KEY
         begin
            MEM_OUT_B = {{24{KEY_MEM[addr[1:0]+0][7]}}, KEY_MEM[addr[1:0]+0]};
            MEM_OUT_H = {{16{KEY_MEM[addr[1:0]+1][7]}}, KEY_MEM[addr[1:0]+1], KEY_MEM[addr[1:0]+0]};
            MEM_OUT_W = {KEY_MEM[addr[1:0]+3], KEY_MEM[addr[1:0]+2], KEY_MEM[addr[1:0]+1], KEY_MEM[addr[1:0]+0]};
            MEM_OUT_BU = {{24{1'b0}}, KEY_MEM[addr[1:0]+0]};
            MEM_OUT_HU = {{16{1'b0}}, KEY_MEM[addr[1:0]+1], KEY_MEM[addr[1:0]+0]};
         end
         16'b0111_1000_0000_00??:         // SW
         begin
            MEM_OUT_B = {{24{SW_MEM[addr[1:0]+0][7]}}, SW_MEM[addr[1:0]+0]};
            MEM_OUT_H = {{16{SW_MEM[addr[1:0]+1][7]}}, SW_MEM[addr[1:0]+1], SW_MEM[addr[1:0]+0]};
            MEM_OUT_W = {SW_MEM[addr[1:0]+3], SW_MEM[addr[1:0]+2], SW_MEM[addr[1:0]+1], SW_MEM[addr[1:0]+0]};
            MEM_OUT_BU = {{24{1'b0}}, SW_MEM[addr[1:0]+0]};
            MEM_OUT_HU = {{16{1'b0}}, SW_MEM[addr[1:0]+1], SW_MEM[addr[1:0]+0]};
         end
         16'b0111_0000_0011_00??:         // 0x7030   (LCD_MEM)
         begin
            MEM_OUT_B = {{24{LCD_MEM[addr[1:0]+0][7]}}, LCD_MEM[addr[1:0]+0]};
            MEM_OUT_H = {{16{LCD_MEM[addr[1:0]+1][7]}}, LCD_MEM[addr[1:0]+1], LCD_MEM[addr[1:0]+0]};
            MEM_OUT_W = {LCD_MEM[addr[1:0]+3], LCD_MEM[addr[1:0]+2], LCD_MEM[addr[1:0]+1], LCD_MEM[addr[1:0]+0]};
            MEM_OUT_BU = {{24{1'b0}}, LCD_MEM[addr[1:0]+0]};
            MEM_OUT_HU = {{16{1'b0}}, LCD_MEM[addr[1:0]+1], LCD_MEM[addr[1:0]+0]};
         end
         16'b0111_0000_0010_01??:         // 0x7024   (HEX_MEM_H)
         begin
            MEM_OUT_B = {{24{HEX_MEM_H[addr[1:0]+0][7]}}, HEX_MEM_H[addr[1:0]+0]};
            MEM_OUT_H = {{16{HEX_MEM_H[addr[1:0]+1][7]}}, HEX_MEM_H[addr[1:0]+1], HEX_MEM_H[addr[1:0]+0]};
            MEM_OUT_W = {HEX_MEM_H[addr[1:0]+3], HEX_MEM_H[addr[1:0]+2], HEX_MEM_H[addr[1:0]+1], HEX_MEM_H[addr[1:0]+0]};
            MEM_OUT_BU = {{24{1'b0}}, HEX_MEM_H[addr[1:0]+0]};
            MEM_OUT_HU = {{16{1'b0}}, HEX_MEM_H[addr[1:0]+1], HEX_MEM_H[addr[1:0]+0]};
         end
         16'b0111_0000_0010_00??:         // 0x7020   (HEX_MEM_L)
         begin
            MEM_OUT_B = {{24{HEX_MEM_L[addr[1:0]+0][7]}}, HEX_MEM_L[addr[1:0]+0]};
            MEM_OUT_H = {{16{HEX_MEM_L[addr[1:0]+1][7]}}, HEX_MEM_L[addr[1:0]+1], HEX_MEM_L[addr[1:0]+0]};
            MEM_OUT_W = {HEX_MEM_L[addr[1:0]+3], HEX_MEM_L[addr[1:0]+2], HEX_MEM_L[addr[1:0]+1], HEX_MEM_L[addr[1:0]+0]};
            MEM_OUT_BU = {{24{1'b0}}, HEX_MEM_L[addr[1:0]+0]};
            MEM_OUT_HU = {{16{1'b0}}, HEX_MEM_L[addr[1:0]+1], HEX_MEM_L[addr[1:0]+0]};
         end
         16'b0111_0000_0001_00??:         // 0x7010   (LEDG_MEM)
         begin
            MEM_OUT_B = {{24{LEDG_MEM[addr[1:0]+0][7]}}, LEDG_MEM[addr[1:0]+0]};
            MEM_OUT_H = {{16{LEDG_MEM[addr[1:0]+1][7]}}, LEDG_MEM[addr[1:0]+1], LEDG_MEM[addr[1:0]+0]};
            MEM_OUT_W = {LEDG_MEM[addr[1:0]+3], LEDG_MEM[addr[1:0]+2], LEDG_MEM[addr[1:0]+1], LEDG_MEM[addr[1:0]+0]};
            MEM_OUT_BU = {{24{1'b0}}, LEDG_MEM[addr[1:0]+0]};
            MEM_OUT_HU = {{16{1'b0}}, LEDG_MEM[addr[1:0]+1], LEDG_MEM[addr[1:0]+0]};
         end
         16'b0111_0000_0000_00??:         // 0x7000   (LEDR_MEM)
         begin
            MEM_OUT_B = {{24{LEDR_MEM[addr[1:0]+0][7]}}, LEDR_MEM[addr[1:0]+0]};
            MEM_OUT_H = {{16{LEDR_MEM[addr[1:0]+1][7]}}, LEDR_MEM[addr[1:0]+1], LEDR_MEM[addr[1:0]+0]};
            MEM_OUT_W = {LEDR_MEM[addr[1:0]+3], LEDR_MEM[addr[1:0]+2], LEDR_MEM[addr[1:0]+1], LEDR_MEM[addr[1:0]+0]};
            MEM_OUT_BU = {{24{1'b0}}, LEDR_MEM[addr[1:0]+0]};
            MEM_OUT_HU = {{16{1'b0}}, LEDR_MEM[addr[1:0]+1], LEDR_MEM[addr[1:0]+0]};
         end
         // 16'b0000_0???_????_????:         // 0x0000 - 0x07FFF  (DMEM)
         // begin
         //    MEM_OUT_B = {{24{DMEM[addr[10:0]+0][7]}}, DMEM[addr[10:0]+0]};
         //    MEM_OUT_H = {{16{DMEM[addr[10:0]+1][7]}}, DMEM[addr[10:0]+1], DMEM[addr[10:0]+0]};
         //    MEM_OUT_W = {DMEM[addr[10:0]+3], DMEM[addr[10:0]+2], DMEM[addr[10:0]+1], DMEM[addr[10:0]+0]};
         //    MEM_OUT_BU = {{24{1'b0}}, DMEM[addr[10:0]+0]};
         //    MEM_OUT_HU = {{16{1'b0}}, DMEM[addr[10:0]+1], DMEM[addr[10:0]+0]};
         // end
         16'b0000_0???_????_????:         // 0x0000 - 0x07FFF  (DMEM)
         begin
            MEM_OUT_B = {{24{DMEM_reg[addr[1:0]+0][7]}}, DMEM_reg[addr[1:0]+0]};
            MEM_OUT_H = {{16{DMEM_reg[addr[1:0]+1][7]}}, DMEM_reg[addr[1:0]+1], DMEM_reg[addr[1:0]+0]};
            MEM_OUT_W = {DMEM_reg[addr[1:0]+3], DMEM_reg[addr[1:0]+2], DMEM_reg[addr[1:0]+1], DMEM_reg[addr[1:0]+0]};
            MEM_OUT_BU = {{24{1'b0}}, DMEM_reg[addr[1:0]+0]};
            MEM_OUT_HU = {{16{1'b0}}, DMEM_reg[addr[1:0]+1], DMEM_reg[addr[1:0]+0]};
         end
         default:
         begin
            MEM_OUT_B = 32'b0;
            MEM_OUT_H = 32'b0;
            MEM_OUT_W = 32'b0;
            MEM_OUT_BU = 32'b0;
            MEM_OUT_HU = 32'b0;
         end
      endcase
   end
   // DATA_MODE_SELECT
   always @(*) begin
      case (data_mode)
         `B: r_data = MEM_OUT_B;
         `H: r_data = MEM_OUT_H;
         `W: r_data = MEM_OUT_W;
         `BU: r_data = MEM_OUT_BU;
         `HU: r_data = MEM_OUT_HU;           
         default: r_data = 32'b0;
      endcase
   end

endmodule