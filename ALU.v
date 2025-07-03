module ALU (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALUOp,
    output logic [31:0] Result,
    output logic Zero
);

    logic [31:0] temp_result;
    logic zero_flag;

    always @(*) begin
        temp_result = 32'b0; // Mặc định kết quả là 0
        case (ALUOp)
            4'd0:    temp_result = A + B;                       // ADD
            4'd1:    temp_result = A - B;                       // SUB
            4'd2:    temp_result = A & B;                       // AND
            4'd3:    temp_result = A | B;                       // OR
            4'd4:    temp_result = A ^ B;                       // XOR
            4'd5:    temp_result = A << B[4:0];                 // SLL
            4'd6:    temp_result = A >> B[4:0];                 // SRL
            4'd7:    temp_result = $signed(A) >>> B[4:0];       // SRA
            4'd8:    temp_result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT
            4'd9:    temp_result = (A < B) ? 32'd1 : 32'd0;      // SLTU
            default: temp_result = 32'b0;
        endcase
    end

    // Cập nhật output Result & Zero
    assign Result = temp_result;
    assign Zero = (temp_result == 32'b0) ? 1'b1 : 1'b0;

endmodule
