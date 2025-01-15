`include "defines.vh"
`timescale 1ns / 1ps

module cpu_test #(
        parameter       DATA_WIDTH  = 8,    // registers are 8 bits in width
        parameter     I_ADDR_WIDTH  = 10   // 2 * 1024 bytes of flash (or ROM in our case)
    );
    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire [7:0] pa;
    wire [7:0] pb;
    wire       oc0a;
    wire       oc0b;
    reg        result;

    wire [I_ADDR_WIDTH-1:0] debug_pc;
    wire [`STATE_COUNT-1:0] debug_state;
    wire [I_ADDR_WIDTH-1:0] debug_vector;
    wire                    debug_irq;
    wire [DATA_WIDTH-1:0]   debug_sreg;

    // Instantiate the Unit Under Test (UUT)
    cpu #(
        .DATA_WIDTH(8),         // registers are 8 bits in width
        .INSTR_WIDTH(16),       // instructions are 16 bits in width
        .I_ADDR_WIDTH(10),      // 2 * 1024 bytes of flash (or ROM in our case)
        .D_ADDR_WIDTH(7),       // 128 bytes of SRAM
        .R_ADDR_WIDTH(5),       // 32 registers
        .RST_ACTIVE_LEVEL(1)
    ) uut (
        .osc_clk(clk),
        .prescaler(5'b0),
`ifdef TRACING
        .trace_mode(1'b0),
        .trace_clk(1'b0),
`endif
        .reset(reset),
        .pa(pa),
        .pb(pb),
        .oc0a(oc0a),
        .oc0b(oc0b),
        .debug_pc(debug_pc),
        .debug_state(debug_state),
        .debug_vector(debug_vector),
        .debug_irq(debug_irq),
        .debug_sreg(debug_sreg)
    );

    initial begin
        // Initialize Inputs
        clk = 1;
        reset = 1;
        // Wait 10 ns for global reset to finish
        #10;
        reset = 0;
        result = 1;

        #360;
        if (debug_vector != `TIM0_COMPA_ISR) begin
            result = 1'bx;
            $display("[FAILED] Vectorul de tratare a intreruperii Compare Match with OCR0A nu este corect!");
        end

        #15; result = 1; #15;
        if (!debug_irq) begin
            result = 1'bx;
            $display("[FAILED] Semnalul IRQ nu este activ pentru intreruperea Compare Match with OCR0A!");
        end

        #15; result = 1; #210;
        if (debug_vector != `TIM0_COMPB_ISR) begin
            result = 1'bx;
            $display("[FAILED] Vectorul de tratare a intreruperii Compare Match with OCR0B nu este corect!");
        end

        #15; result = 1; #15;
        if (!debug_irq) begin
            result = 1'bx;
            $display("[FAILED] Semnalul IRQ nu este activ pentru intreruperea Compare Match with OCR0B!");
        end
        
        #100;
`ifndef SEI_FOUND
    result = 1'bx;
    $display("[FAILED] Instructiunea SEI/CLI nu este implementata!");
`else
        #15; result = 1; #110;
        if (!debug_sreg[`FLAGS_I]) begin
            result = 1'bx;
            $display("[FAILED] Instructiunea SEI/CLI nu activeaza corect intreruperile!");
        end
`endif

        #15; result = 1; #2265;
        if (!pa[0]) begin
            result = 1'bx;
            $display("[FAILED] Instructiunea CALL_ISR nu este implementata corect!");
        end

        #15; result = 1; #665;
        if (debug_pc != 31) begin
            result = 1'bx;
            $display("[FAILED] Instructiunea RETI nu este implementata corect!");
        end
        
    end
    always clk = #5 ~clk;

endmodule
