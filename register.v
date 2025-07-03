
module register (
    input wire clk,
    input wire en,
    input wire [7:0] in,
    output reg [7:0] out
);
    always @(posedge clk) begin
        if (en) begin
            out <= in;
        end
    end
endmodule



module regblock (
    input wire clk,
    input wire [7:0] idata,
    output wire [7:0] odata,

    input wire we,
    input wire oe,
    input wire [2:0] oaddr,
    input wire [2:0] iaddr,

    output wire [7:0] rega,
    output wire [7:0] regb
);
    reg [7:0] registers[0:7];

    assign odata = oe ? registers[oaddr] : 8'bz;
    assign rega = registers[0];
    assign regb = registers[1];

    always @(posedge clk) begin
        if (we) begin
            registers[iaddr] <= idata;
        end
    end
endmodule
