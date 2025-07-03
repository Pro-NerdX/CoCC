
module RAM (
    input wire clk,

    inout wire[7:0] data_bus,

    input wire we,
    input wire oe,
    input wire[7:0] addr
);
    reg[7:0] mem[0:255];

    assign data_bus = (oe & ~we) ? mem[addr] : 8'bz;
    
    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data_bus;
        end
    end

    // copy ROM to RAM; loads RAM-img
    initial begin
        $readmemh("rom.hex", mem);
    end
endmodule
