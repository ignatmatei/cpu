`include "defines.vh"
module decode_unit #(
        parameter  INSTR_WIDTH  = 16,
        parameter  R_ADDR_WIDTH = 5
    )(
        input  wire   [INSTR_WIDTH-1:0] instruction,
        output reg  [`OPCODE_COUNT-1:0] opcode_type,
        output wire  [`GROUP_COUNT-1:0] opcode_group,
        output reg   [R_ADDR_WIDTH-1:0] opcode_rd,
        output reg   [R_ADDR_WIDTH-1:0] opcode_rr,
        output reg               [11:0] opcode_imd,
        output reg                [2:0] opcode_bit,
        input  wire                     irq
    );

    always @* begin
        // TODO 3: Daca avem o cerere de intrerupere, trebuie sa executam instructiunea virtuala
        // CALL_ISR in loc sa decodificam o instructiune.
        //      - HINT: Ce semnal ne indica faptul ca avem o cerere de intrerupere?
        //      - HINT: Instructiunea virtuala CALL_ISR nu are nevoie decat de opcode_type.
        if (irq) begin
            opcode_type = `TYPE_CALL_ISR;
            opcode_rd   = {R_ADDR_WIDTH{1'bx}};
            opcode_rr   = {R_ADDR_WIDTH{1'bx}};
            opcode_bit  = 3'bx;
            opcode_imd  = 12'bx;
        end else begin
            casez (instruction)
                16'b0000_11??_????_????: begin
                    opcode_type = `TYPE_ADD;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {instruction[9], instruction[3:0]};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b0001_11??_????_????: begin
                    opcode_type = `TYPE_ADC;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {instruction[9], instruction[3:0]};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b0010_00??_????_????: begin
                    opcode_type = `TYPE_AND;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {instruction[9], instruction[3:0]};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b1111_01??_????_????: begin
                    opcode_type = `TYPE_BRBC;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = instruction[2:0];
                    opcode_imd  = {{5{instruction[9]}}, instruction[9:3]};
                end
                16'b1111_00??_????_????: begin
                    opcode_type = `TYPE_BRBS;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = instruction[2:0];
                    opcode_imd  = {{5{instruction[9]}}, instruction[9:3]};
                end
                16'b1001_1000_????_????: begin
                    opcode_type = `TYPE_CBI;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = instruction[2:0];
                    opcode_imd  = {7'b0, instruction[7:3]};
                end
                
                // TODO 2: Trebuie sa decodificam CLI.
                //  - HINT: CLI se comporta ca un CBI cu operandul bit hard-codat. Ce valoare trebuie
                //  sa ia acest operand?
                16'b1001_0100_1111_1000: begin
                    opcode_type = `TYPE_CLI;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = `FLAGS_I;
                    opcode_imd  = `SREG;
                end

                16'b0001_01??_????_????: begin
                    opcode_type = `TYPE_CP;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {instruction[9], instruction[3:0]};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b1001_010?_????_1010: begin
                    opcode_type = `TYPE_DEC;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b0010_01??_????_????: begin
                    opcode_type = `TYPE_EOR;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {instruction[9], instruction[3:0]};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b1011_0???_????_????: begin
                    opcode_type = `TYPE_IN;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = {instruction[10:9], instruction[3:0]};
                end
                16'b1001_010?_????_0011: begin
                    opcode_type = `TYPE_INC;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b1000_000?_????_1000: begin
                    opcode_type = `TYPE_LD_Y;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b1110_????_????_????: begin
                    opcode_type = `TYPE_LDI;
                    opcode_rd   = {1'b1, instruction[7:4]};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = {4'b0, instruction[11:8], instruction[3:0]};
                end
                16'b1010_0???_????_????: begin
                    opcode_type = `TYPE_LDS;
                    opcode_rd   = {1'b1, instruction[7:4]};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    // info extracted from the datasheet
                    opcode_imd  = {~instruction[8], instruction[8],
                        instruction[10:9], instruction[3:0]};
                end
                16'b0010_11??_????_????: begin
                    opcode_type = `TYPE_MOV;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {instruction[9], instruction[3:0]};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b1001_010?_????_0001: begin
                    opcode_type = `TYPE_NEG;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b0000_0000_0000_0000: begin
                    opcode_type = `TYPE_NOP;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b0010_10??_????_????: begin
                    opcode_type = `TYPE_OR;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {instruction[9], instruction[3:0]};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b1011_1???_????_????: begin
                    opcode_type = `TYPE_OUT;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = instruction[8:4];
                    opcode_bit  = 3'bx;
                    opcode_imd  = {instruction[10:9], instruction[3:0]};
                end
                16'b1001_000?_????_1111: begin
                    opcode_type = `TYPE_POP;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b1001_001?_????_1111: begin
                    opcode_type = `TYPE_PUSH;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = instruction[8:4];
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b1101_????_????_????: begin
                    opcode_type = `TYPE_RCALL;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = instruction[11:0];
                end
                16'b1001_0101_0000_1000: begin
                    opcode_type = `TYPE_RET;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                
                // TODO 3: Trebuie sa decodificam RETI.
                //  - HINT: RETI se comporta exact ca un RET.
                16'b1001_0101_0001_1000: begin
                    opcode_type = `TYPE_RETI;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end

                16'b1100_????_????_????: begin
                    opcode_type = `TYPE_RJMP;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = instruction[11:0];
                end
                16'b1001_1010_????_????: begin
                    opcode_type = `TYPE_SBI;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = instruction[2:0];
                    opcode_imd  = {7'b0, instruction[7:3]};
                end
                
                // TODO 2: Trebuie sa decodificam SEI.
                //  - HINT: SEI se comporta ca un SBI cu operandul bit hard-codat. Ce valoare trebuie
                //  sa ia acest operand?
                16'b1001_0100_0111_1000: begin
                    opcode_type = `TYPE_SEI;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = `FLAGS_I;
                    opcode_imd  = `SREG;
                end
                
                16'b0001_10??_????_????: begin
                    opcode_type = `TYPE_SUB;
                    opcode_rd   = instruction[8:4];
                    opcode_rr   = {instruction[9], instruction[3:0]};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
                16'b0101_????_????_????: begin
                    opcode_type = `TYPE_SUBI;
                    opcode_rd   = {1'b1, instruction[7:4]};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = {4'b0, instruction[7:4], instruction[3:0]};
                end
                16'b1010_1???_????_????: begin
                    opcode_type = `TYPE_STS;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {1'b1, instruction[7:4]};
                    opcode_bit  = 3'bx;
                    // info extracted from the datasheet
                    opcode_imd  = {~instruction[8], instruction[8],
                        instruction[10:9], instruction[3:0]};
                end
                default: begin
                    opcode_type = `TYPE_UNKNOWN;
                    opcode_rd   = {R_ADDR_WIDTH{1'bx}};
                    opcode_rr   = {R_ADDR_WIDTH{1'bx}};
                    opcode_bit  = 3'bx;
                    opcode_imd  = 12'bx;
                end
            endcase
        end
    end

    // TODO 2: Trebuie sa adaugam SEI si CLI in grupurile necesare.
    //  - HINT: SEI se comporta exact ca un SBI.
    //  - HINT: CLI se comporta exact ca un CBI.

    // TODO 3: Trebuie sa adaugam CALL_ISR si RETI in grupurile necesare.
    //  - HINT: CALL_ISR se comporta exact ca un RCALL + CLI.
    //  - HINT: RETI se comporta exact ca un RET + SEI.

    /* Opcode groups */
    assign opcode_group[`GROUP_ALU_AUX] =
        (opcode_type == `TYPE_SBI) ||
        (opcode_type == `TYPE_CBI) ||
        (opcode_type == `TYPE_SEI) ||
        (opcode_type == `TYPE_CLI) ||
        (opcode_type == `TYPE_RETI)||
        (opcode_type == `TYPE_CALL_ISR);
    assign opcode_group[`GROUP_ALU_IMD] =
        (opcode_type == `TYPE_INC) ||
        (opcode_type == `TYPE_DEC) ||
        (opcode_type == `TYPE_CPI);
    assign opcode_group[`GROUP_ALU_ONE_OP] =
        (opcode_type == `TYPE_NEG);
    assign opcode_group[`GROUP_ALU_TWO_OP] =
        (opcode_type == `TYPE_ADD) ||
        (opcode_type == `TYPE_ADC) ||
        (opcode_type == `TYPE_SUB) ||
        (opcode_type == `TYPE_AND) ||
        (opcode_type == `TYPE_EOR) ||
        (opcode_type == `TYPE_OR)  ||
        (opcode_type == `TYPE_CP);
    assign opcode_group[`GROUP_ALU] =
        opcode_group[`GROUP_ALU_ONE_OP] ||
        opcode_group[`GROUP_ALU_TWO_OP];

    assign opcode_group[`GROUP_LOAD_DIRECT] =
        (opcode_type == `TYPE_LDS);

    assign opcode_group[`GROUP_LOAD_INDIRECT] =
        (opcode_type == `TYPE_LD_Y) ||
        (opcode_type == `TYPE_POP) ||
        (opcode_type == `TYPE_RET) ||
        (opcode_type == `TYPE_RETI);
    assign opcode_group[`GROUP_LOAD] =
        opcode_group[`GROUP_LOAD_DIRECT] ||
        opcode_group[`GROUP_LOAD_INDIRECT];

    assign opcode_group[`GROUP_STORE_DIRECT] =
        (opcode_type == `TYPE_STS);

    assign opcode_group[`GROUP_STORE_INDIRECT] =
        (opcode_type == `TYPE_PUSH)  ||
        (opcode_type == `TYPE_RCALL) ||
        (opcode_type == `TYPE_CALL_ISR);
    assign opcode_group[`GROUP_STORE] =
        opcode_group[`GROUP_STORE_DIRECT] ||
        opcode_group[`GROUP_STORE_INDIRECT];

    assign opcode_group[`GROUP_STACK] =
        (opcode_type == `TYPE_PUSH)     ||
        (opcode_type == `TYPE_POP)      ||
        (opcode_type == `TYPE_RCALL)    ||
        (opcode_type == `TYPE_CALL_ISR) ||
        (opcode_type == `TYPE_RETI)     ||
        (opcode_type == `TYPE_RET);

    assign opcode_group[`GROUP_MEMORY] =
        (opcode_group[`GROUP_LOAD] ||
         opcode_group[`GROUP_STORE]);

    assign opcode_group[`GROUP_REGISTER] =
        (opcode_type == `TYPE_LDI) ||
        (opcode_type == `TYPE_MOV);

    assign opcode_group[`GROUP_CONTROL_FLOW] =
        (opcode_type == `TYPE_BRBS)  ||
        (opcode_type == `TYPE_BRBC)  ||
        (opcode_type == `TYPE_RJMP)  ||
        (opcode_type == `TYPE_RCALL) ||
        (opcode_type == `TYPE_RET) ||
        (opcode_type == `TYPE_CALL_ISR) ||
        (opcode_type == `TYPE_RETI);

    assign opcode_group[`GROUP_IO_READ] =
        (opcode_type  == `TYPE_IN)  ||   // access any I/O address
        (opcode_type  == `TYPE_ADC) ||   // access SREG
        (opcode_group[`GROUP_STACK])||   // access SP
        (opcode_group[`GROUP_ALU_AUX]);  // read value to modify from I/O space
    assign opcode_group[`GROUP_IO_WRITE] =
        (opcode_type  == `TYPE_OUT) ||   // access any I/O address
        (opcode_group[`GROUP_ALU])  ||   // access SREG
        (opcode_group[`GROUP_STACK])||   // access SP
        (opcode_group[`GROUP_ALU_AUX]);  // write modified value to I/O space

    // must read/write a 10-bit program counter from stack
    assign opcode_group[`GROUP_TWO_CYCLE_MEM] =
        (opcode_type == `TYPE_RCALL)    ||
        (opcode_type == `TYPE_CALL_ISR) ||
        (opcode_type == `TYPE_RETI)     ||
        (opcode_type == `TYPE_RET);

    // must write SPL and SREG to I/O space
    assign opcode_group[`GROUP_TWO_CYCLE_WB] =
        (opcode_type == `TYPE_CALL_ISR) ||
        (opcode_type == `TYPE_RETI);
    // must read SPL and SREG from I/O space
    assign opcode_group[`GROUP_TWO_CYCLE_ID] =
        (opcode_type == `TYPE_CALL_ISR) ||
        (opcode_type == `TYPE_RETI);

endmodule
