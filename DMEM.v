module DMEM (
    input logic clk,
    input logic rst_n,
    input logic MemRead,
    input logic MemWrite,
    input logic [31:0] addr,
    input logic [31:0] WriteData,
    output logic [31:0] ReadData
);

    logic [31:0] data_mem [0:255];
    logic [31:0] read_data_tmp;

    // Gán giá trị đọc bộ nhớ
    assign ReadData = (MemRead == 1'b1) ? data_mem[addr[9:2]] : 32'b0;

    // Khối always để reset và ghi bộ nhớ
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int idx = 0; idx < 256; idx = idx + 1)
                data_mem[idx] <= 32'b0;
        end else if (MemWrite) begin
            data_mem[addr[9:2]] <= WriteData;
        end
    end

    // Khối initial nạp dữ liệu bộ nhớ
    initial begin
        if ($fopen("./mem/dmem_init.hex", "r"))
            $readmemh("./mem/dmem_init.hex", data_mem);
        else if ($fopen("./mem/dmem_init2.hex", "r"))
            $readmemh("./mem/dmem_init2.hex", data_mem);
    end

endmodule
