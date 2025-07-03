module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [1:0] ALUSrc,
    output logic [3:0] ALUOp,
    output logic Branch,
    output logic MemRead,
    output logic MemWrite,
    output logic MemToReg,
    output logic RegWrite
);

    logic [1:0] alu_src_tmp;
    logic [3:0] alu_op_tmp;
    logic branch_tmp;
    logic mem_read_tmp;
    logic mem_write_tmp;
    logic mem_to_reg_tmp;
    logic reg_write_tmp;

    always_comb begin
        // Thiết lập mặc định
        alu_src_tmp     = 2'b00;
        alu_op_tmp      = 4'b0000;
        branch_tmp      = 1'b0;
        mem_read_tmp    = 1'b0;
        mem_write_tmp   = 1'b0;
        mem_to_reg_tmp  = 1'b0;
        reg_write_tmp   = 1'b0;

        case (opcode)
            7'b0110011: begin // R-type
                alu_src_tmp = 2'b00;
                reg_write_tmp = 1'b1;
                case ({funct7, funct3})
                    10'b0000000000: alu_op_tmp = 4'b0000; // add
                    10'b0100000000: alu_op_tmp = 4'b0001; // sub
                    10'b0000000111: alu_op_tmp = 4'b0010; // and
                    10'b0000000110: alu_op_tmp = 4'b0011; // or
                    10'b0000000100: alu_op_tmp = 4'b0100; // xor
                    10'b0000000001: alu_op_tmp = 4'b0101; // sll
                    10'b0000000101: alu_op_tmp = 4'b0110; // srl
                    10'b0100000101: alu_op_tmp = 4'b0111; // sra
                    10'b0000000010: alu_op_tmp = 4'b1000; // slt
                    10'b0000000011: alu_op_tmp = 4'b1001; // sltu
                    default: alu_op_tmp = 4'b0000;
                endcase
            end
            7'b0010011: begin // I-type
                alu_src_tmp = 2'b01;
                reg_write_tmp = 1'b1;
                case (funct3)
                    3'b000: alu_op_tmp = 4'b0000; // addi
                    3'b111: alu_op_tmp = 4'b0010; // andi
                    3'b110: alu_op_tmp = 4'b0011; // ori
                    3'b100: alu_op_tmp = 4'b0100; // xori
                    3'b001: alu_op_tmp = 4'b0101; // slli
                    3'b101: alu_op_tmp = (funct7 == 7'b0000000) ? 4'b0110 : 4'b0111; // srli/srai
                    3'b010: alu_op_tmp = 4'b1000; // slti
                    3'b011: alu_op_tmp = 4'b1001; // sltiu
                    default: alu_op_tmp = 4'b0000;
                endcase
            end
            7'b0000011: begin // load
                alu_src_tmp    = 2'b01;
                mem_read_tmp   = 1'b1;
                mem_to_reg_tmp = 1'b1;
                reg_write_tmp  = 1'b1;
                alu_op_tmp     = 4'b0000; // address = rs1 + imm
            end
            7'b0100011: begin // store
                alu_src_tmp    = 2'b01;
                mem_write_tmp  = 1'b1;
                alu_op_tmp     = 4'b0000;
            end
            7'b1100011: begin // branch
                branch_tmp  = 1'b1;
                alu_op_tmp  = 4'b0001; // sub to compare
            end
            7'b1101111, // jal
            7'b1100111: begin // jalr
                alu_src_tmp    = 2'b01;
                reg_write_tmp  = 1'b1;
                mem_to_reg_tmp = 1'b0;
                alu_op_tmp     = 4'b0000;
            end
            default: ; // Không làm gì
        endcase
    end

    // Gán ra output
    assign ALUSrc   = alu_src_tmp;
    assign ALUOp    = alu_op_tmp;
    assign Branch   = branch_tmp;
    assign MemRead  = mem_read_tmp;
    assign MemWrite = mem_write_tmp;
    assign MemToReg = mem_to_reg_tmp;
    assign RegWrite = reg_write_tmp;

endmodule
