module dff(
    input D,
    input clk,
    output reg Q,
    output notQ
    );
    initial Q = 0;
    assign notQ = ~Q;
    always @(posedge clk) begin
        Q <= D;
    end
    
endmodule
