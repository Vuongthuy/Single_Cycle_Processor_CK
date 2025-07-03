module RISCV_Single_Cycle(
    input logic clk,
    input logic rst_n,
    output logic [31:0] PC_out_top,
    output logic [31:0] Instruction_out_top
);

    // --- Khai báo các biến tạm ---
    logic [31:0] pc_next_tmp;
    logic [31:0] Imm;
    logic [4:0] rs1_tmp, rs2_tmp, rd_tmp;
    logic [2:0] funct3_tmp;
    logic [6:0] opcode_tmp, funct7_tmp;
    logic [31:0] reg_data1, reg_data2, wb_data;
    logic [31:0] alu_in2_tmp, alu_result_tmp;
    logic alu_zero_flag;
    logic [31:0] mem_read_data_tmp;
    logic [1:0] alu_src_tmp;
    logic [3:0] alu_ctrl_tmp;
    logic branch_flag, mem_read_flag, mem_write_flag, mem2reg_flag, reg_write_flag, pc_sel_flag;

    // --- Cập nhật PC ---
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            PC_out_top <= 32'b0;
        else
            PC_out_top <= pc_next_tmp;
    end

    // --- Khởi tạo module bộ nhớ lệnh ---
    IMEM IMEM_inst( // BẮT BUỘC ĐÚNG TÊN INSTANCE NÀY!
        .addr(PC_out_top),
        .Instruction(Instruction_out_top)
    );

    // --- Phân tách trường lệnh ---
    assign opcode_tmp = Instruction_out_top[6:0];
    assign rd_tmp     = Instruction_out_top[11:7];
    assign funct3_tmp = Instruction_out_top[14:12];
    assign rs1_tmp    = Instruction_out_top[19:15];
    assign rs2_tmp    = Instruction_out_top[24:20];
    assign funct7_tmp = Instruction_out_top[31:25];

    // --- Sinh hằng số ---
    Imm_Gen imm_gen_inst(
        .inst(Instruction_out_top),
        .imm_out(Imm)
    );

    // --- Register File (instance phải là Reg_inst cho tb) ---
    RegisterFile Reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .RegWrite(reg_write_flag),
        .rs1(rs1_tmp),
        .rs2(rs2_tmp),
        .rd(rd_tmp),
        .WriteData(wb_data),
        .ReadData1(reg_data1),
        .ReadData2(reg_data2)
    );

    // --- Lựa chọn input 2 cho ALU ---
    assign alu_in2_tmp = (alu_src_tmp[0]) ? Imm : reg_data2;

    // --- ALU ---
    ALU alu_inst(
        .A(reg_data1),
        .B(alu_in2_tmp),
        .ALUOp(alu_ctrl_tmp),
        .Result(alu_result_tmp),
        .Zero(alu_zero_flag)
    );

    // --- Data Memory ---
    DMEM DMEM_inst( // BẮT BUỘC ĐÚNG TÊN INSTANCE NÀY!
        .clk(clk),
        .rst_n(rst_n),
        .MemRead(mem_read_flag),
        .MemWrite(mem_write_flag),
        .addr(alu_result_tmp),
        .WriteData(reg_data2),
        .ReadData(mem_read_data_tmp)
    );

    // --- Write-back multiplexer ---
    assign wb_data = (mem2reg_flag) ? mem_read_data_tmp : alu_result_tmp;

    // --- Control unit ---
    control_unit ctrl_unit_inst(
        .opcode(opcode_tmp),
        .funct3(funct3_tmp),
        .funct7(funct7_tmp),
        .ALUSrc(alu_src_tmp),
        .ALUOp(alu_ctrl_tmp),
        .Branch(branch_flag),
        .MemRead(mem_read_flag),
        .MemWrite(mem_write_flag),
        .MemToReg(mem2reg_flag),
        .RegWrite(reg_write_flag)
    );

    // --- Bộ so sánh điều kiện nhảy ---
    Branch_Comp branch_comp_inst(
        .A(reg_data1),
        .B(reg_data2),
        .Branch(branch_flag),
        .funct3(funct3_tmp),
        .BrTaken(pc_sel_flag)
    );

    // --- Logic cập nhật PC ---
    assign pc_next_tmp = (pc_sel_flag) ? PC_out_top + Imm : PC_out_top + 4;

endmodule
