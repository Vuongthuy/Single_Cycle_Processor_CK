module ALU_decoder(
    input  [1:0] alu_op,
    input  [2:0] funct3,
    input        funct7b5,
    output logic [3:0] alu_control
);

    logic [3:0] alu_ctrl_tmp;

    always_comb begin
        alu_ctrl_tmp = 4'b0010; // Mặc định là ADD (cho load/store)
        unique case (alu_op)
            2'b00: alu_ctrl_tmp = 4'b0010; // ADD (load/store)
            2'b01: alu_ctrl_tmp = 4'b0110; // SUB (branch)
            2'b10: begin // R-type hoặc I-type
                unique case (funct3)
                    3'b000: alu_ctrl_tmp = (funct7b5 ? 4'b0110 : 4'b0010); // SUB : ADD
                    3'b111: alu_ctrl_tmp = 4'b0000; // AND
                    3'b110: alu_ctrl_tmp = 4'b0001; // OR
                    3'b010: alu_ctrl_tmp = 4'b0111; // SLT
                    default: alu_ctrl_tmp = 4'b0010;
                endcase
            end
            default: alu_ctrl_tmp = 4'b0010;
        endcase
    end

    // Gán giá trị ra output
    assign alu_control = alu_ctrl_tmp;

endmodule
