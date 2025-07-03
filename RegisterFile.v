module RegisterFile (
    input logic clk,
    input logic RegWrite,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] WriteData,
    output logic [31:0] ReadData1,
    output logic [31:0] ReadData2,
    input logic rst_n
);

    logic [31:0] reg_array [0:31];
    logic [31:0] read1_tmp, read2_tmp;

    // Đọc dữ liệu từ các thanh ghi, x0 luôn bằng 0
    assign read1_tmp = (rs1 == 0) ? 32'b0 : reg_array[rs1];
    assign read2_tmp = (rs2 == 0) ? 32'b0 : reg_array[rs2];
    assign ReadData1 = read1_tmp;
    assign ReadData2 = read2_tmp;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int idx = 0; idx < 32; idx = idx + 1)
                reg_array[idx] <= 32'b0;
        end else if (RegWrite && (rd != 0)) begin
            reg_array[rd] <= WriteData;
        end
    end

endmodule
