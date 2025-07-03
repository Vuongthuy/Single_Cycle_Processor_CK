module IMEM (
    input  [31:0] addr,
    output [31:0] Instruction
);

    reg [31:0] instr_mem [0:255];
    wire [31:0] instr_tmp;

    // Nếu địa chỉ hợp lệ (<128), trả về lệnh; nếu không, trả về lệnh halt (beq x0, x0, 0)
    assign instr_tmp = (addr[11:2] >= 128) ? 32'h00000063 : instr_mem[addr[11:2]];
    assign Instruction = instr_tmp;

    initial begin
        if ($fopen("./mem/imem.hex", "r"))
            $readmemh("./mem/imem.hex", instr_mem);
        else if ($fopen("./mem/imem2.hex", "r"))
            $readmemh("./mem/imem2.hex", instr_mem);
    end

endmodule
