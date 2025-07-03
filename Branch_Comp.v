module Branch_Comp (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic Branch,
    input  logic [2:0] funct3,
    output logic BrTaken
);

    logic br_flag;

    always_comb begin
        br_flag = 1'b0; // Mặc định không nhảy
        if (Branch) begin
            case (funct3)
                3'b000: br_flag = ~(A ^ B);                              // beq (A==B): ~(A^B) là true nếu bằng nhau
                3'b001: br_flag = |(A ^ B);                              // bne (A!=B): A^B khác 0 nếu khác nhau
                3'b100: br_flag = ($signed(A) < $signed(B));             // blt
                3'b101: br_flag = ~($signed(A) < $signed(B));            // bge
                3'b110: br_flag = (A < B);                               // bltu
                3'b111: br_flag = ~(A < B);                              // bgeu
                default: br_flag = 1'b0;
            endcase
        end
    end

    assign BrTaken = br_flag;

endmodule
