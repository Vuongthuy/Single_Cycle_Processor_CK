module IMEM (
    input  [31:0] addr,
    output [31:0] Instruction
);

    reg [31:0] memory [0:255];
    wire [31:0] instr_tmp;

    assign instr_tmp = (addr[11:2] >= 128) ? 32'h00000063 : memory[addr[11:2]];
    assign Instruction = instr_tmp;

    initial begin
        if ($fopen("./mem/imem.hex", "r"))
            $readmemh("./mem/imem.hex", memory);
        else if ($fopen("./mem/imem2.hex", "r"))
            $readmemh("./mem/imem2.hex", memory);
    end

endmodule
