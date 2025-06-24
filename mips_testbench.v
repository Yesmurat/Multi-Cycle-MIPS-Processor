module testbench ();

        reg clk;
        reg reset;
        wire [31:0] writedata, adr;
        wire memwrite;

        // instantiate device to be tested
        top dut(clk, reset, writedata, adr, memwrite);

        // initialize test
        initial clk = 0;
        always #5 clk = ~clk;

        initial begin
            reset <= 1; #22; reset <= 0;
            // assert reset for 22 nanoseconds and deassert it
            // used to bring the processor into a known state before execution begins
        end

        initial begin
            $dumpfile("dump.vcd");
            $dumpvars;
        end

        // always @(posedge clk) begin
        //     if (memwrite) begin
        //         if (adr == 0 & writedata == 5) begin
        //             $display("Simulation succeeded");
        //         end
        //     end else begin
        //         $display("Simulation failed");
        //     end
        // end

    
endmodule