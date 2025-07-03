module DMEM (
    input logic clk,
    input logic rst_n,
    input logic MemRead,
    input logic MemWrite,
    input logic [31:0] addr,
    input logic [31:0] WriteData,
    output logic [31:0] ReadData
);

    logic [31:0] memory [0:255];

    // Đọc dữ liệu từ bộ nhớ
    assign ReadData = (MemRead == 1'b1) ? memory[addr[9:2]] : 32'b0;

    // Ghi bộ nhớ hoặc reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int idx = 0; idx < 256; idx = idx + 1)
                memory[idx] <= 32'b0;
        end else if (MemWrite) begin
            memory[addr[9:2]] <= WriteData;
        end
    end

    // Nạp dữ liệu initial
    initial begin
        if ($fopen("./mem/dmem_init.hex", "r"))
            $readmemh("./mem/dmem_init.hex", memory);
        else if ($fopen("./mem/dmem_init2.hex", "r"))
            $readmemh("./mem/dmem_init2.hex", memory);
    end

endmodule
