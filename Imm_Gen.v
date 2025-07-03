module Imm_Gen (
    input  logic [31:0] inst,
    output logic [31:0] imm_out
);

    wire [6:0] op = inst[6:0];
    logic [31:0] imm_val_tmp;

    always @(*) begin
        imm_val_tmp = 32'b0;
        // I-type
        if (op == 7'b0000011 || op == 7'b0010011 || op == 7'b1100111) begin
            imm_val_tmp = {{20{inst[31]}}, inst[31:20]};
        end
        // S-type
        else if (op == 7'b0100011) begin
            imm_val_tmp = {{20{inst[31]}}, inst[31:25], inst[11:7]};
        end
        // B-type
        else if (op == 7'b1100011) begin
            imm_val_tmp = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
        end
        // U-type (auipc/lui)
        else if (op == 7'b0010111 || op == 7'b0110111) begin
            imm_val_tmp = {inst[31:12], 12'b0};
        end
        // J-type (jal)
        else if (op == 7'b1101111) begin
            imm_val_tmp = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
        end
        else begin
            imm_val_tmp = 32'b0;
        end
    end

    assign imm_out = imm_val_tmp;

endmodule
