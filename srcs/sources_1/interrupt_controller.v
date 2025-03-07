`include "defines.vh"
module interrupt_controller #(
        parameter   DATA_WIDTH = 8,
        parameter I_ADDR_WIDTH = 10
    )(
        input wire                    clk,
        input wire                    reset,
        input wire   [DATA_WIDTH-1:0] mem_tifr,
        input wire   [DATA_WIDTH-1:0] mem_timsk,
        input wire   [DATA_WIDTH-1:0] mem_sreg,
        output reg                    irq,
        output reg [I_ADDR_WIDTH-1:0] vector
    );

    always @(posedge clk) begin
        if (reset) begin
            irq    <= 0;
            vector <= 0;
        end else begin
            // TODO 1: Inlocuiti semnele de intrebare din codul de mai jos 
            // 
            // Trebuie sa determinam daca vom genera o cerere de intrerupere sau nu. 
            //
            // E.g.: Pentru a genera o cerere de intrerupere pentru intreruperea TIM0_OVF, trebuie
            // sa se intample 3 lucruri:
            //  - Intreruperile trebuie sa fie activate global
            //          - Care bit din SREG ne poate ajuta?   --  FLAGS_I
            //  - Intreruperea TIM0_OVF trebuie sa sa fie demascata
            //          - Care bit din TIMSK (vezi pag 74 din datasheet) ne poate ajuta?  --  TOIE0
            //  - Timer/Counter0 trebuie sa fi facut overflow
            //          - Care bit din TIFR (vezi pag 75 din datasheet) ne poate ajuta?   --  TOV0
            //
            // Daca aceste 3 conditii sunt adevarate, atunci vom genera o cerere de intrerupere si
            // vom transmite vectorul de intrerupere TIM0_OVF_ISR.
            //  - HINT: Ce valori trebuie sa ia variabilele irq si vector?
            //
            // Aceeasi logica o vom aplica si pentru intreruperile TIM0_COMPA si TIM0_COMPB.
            if (mem_sreg[`FLAGS_I] && mem_timsk[`TOIE0] && mem_tifr[`TOV0]) begin
                irq    <= 1;
                vector <= `TIM0_OVF_ISR;
            end else if (mem_sreg[`FLAGS_I] && mem_timsk[`OCIE0A] && mem_tifr[`OCF0A]) begin
                irq    <= 1;
                vector <= `TIM0_COMPA_ISR;
            end else if (mem_sreg[`FLAGS_I] && mem_timsk[`OCIE0B] && mem_tifr[`OCF0B]) begin
                irq    <= 1;
                vector <= `TIM0_COMPB_ISR;
            end else begin
                irq    <= 0;
                // Trebuie sa lasam variabila vector la valoarea anterioara
                // pentru a putea sti la ce intrerupere facem ACK.
            end
        end
    end
endmodule
