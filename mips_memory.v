module mem (
    input clk, reset, memwrite,
    input [31:0] adr,
    input [31:0] writedata,
    output [31:0] readdata
);

        reg [31:0] RAM[63:0];

        initial begin
            $readmemh("mem.mem", RAM, 0, 2);
        end

        assign readdata = RAM[adr[31:2]];
        always @(posedge clk) begin
            if (memwrite)
                    RAM[adr[31:2]] <= writedata;
        end


    
endmodule