module flopenr #(
    parameter WIDTH = 8
) (
    input wire clk, reset,
    input wire enable,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk, posedge reset) begin
    if (reset) q <= 0;
    else
        if (enable) q <= d;
end
    
endmodule // register

module mux2 #(
    parameter WIDTH = 8
) (
    input wire [WIDTH-1:0] d0, d1,
    input wire select,
    output wire [WIDTH-1:0] result
); // 2-to-1 mux

assign result = select ? d1: d0;
endmodule

module mux3 #(
    parameter WIDTH = 8
) (
    input wire [WIDTH-1:0] d0, d1, d2,
    input wire [1:0] select,
    output wire [WIDTH-1:0] result
);

assign #1 result = select[1] ? d2: (select[0] ? d1: d0);
endmodule // 3-to-1 mux

module mux4 #(
    parameter WIDTH = 8
) (
    input wire [WIDTH-1:0] d0, d1, d2, d3,
    input wire [1:0] select,
    output reg [WIDTH-1:0] result
);

always @(*) begin
    case (select)
        2'b00: result = d0;
        2'b01: result = d1;
        2'b10: result = d2;
        2'b11: result = d3;
        default: result = {WIDTH{1'bx}};
    endcase
end
endmodule // 4-to-1 mux

module regfile (
    input clk,
    input we3,
    input [4:0] a1, a2, a3,
    input [31:0] wd3,
    output [31:0] rd1, rd2
);

reg [31:0] rf[31:0];

always @(posedge clk) 
        if (we3) rf[a3] <= wd3;

assign rd1 = (a1 != 0) ? rf[a1] : 0;
assign rd2 = (a2 != 0) ? rf[a2] : 0;
endmodule // register file

module sl2 (
    input [31:0] a,
    output [31:0] y
);

assign y = {a[29:0], 2'b00};
endmodule // shift left by 2

module signext (
    input [15:0] a,
    output [31:0] y
);

assign y = {{16{a[15]}}, a};
endmodule

module alu (
    input [31:0] a, b, // ALU inputs
    input [2:0] f, // ALU_control_bit to control ALU operation
    output reg [31:0] y, // ALU_output
    output zero // Zero_indicator_bit to indicate zero value output
);

// This is switch case on the control bits that control the operation of the ALU
always @(f, a, b) begin
    case (f)
        // AND_operation
        0: y = a & b;
        // OR_operation
        1: y = a | b;
        // ADD_operation
        2: y = a + b;
        // SUB operation
        6: y = a + (~b+1);
        // SLT_operation
        7: y = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
    endcase
end

// Checking the zero flag bit that indicate the zero value output
assign zero = (y == 0);
    
endmodule