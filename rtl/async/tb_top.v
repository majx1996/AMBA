`define RD 1

module tb_top ();


localparam T_CLKS = 5   ; 
localparam T_CLKD = 5   ; 
localparam DW     = 8   ; 
localparam TS     = 0.5 ; 
localparam TH     = 0.5 ; 

logic clk_s           ; 
logic clk_d           ; 
logic rstn_d          ; 
logic [DW-1:0] data_s ; 
logic [DW-1:0] data_d ; 


initial begin
    clk_s = 0;

    # 0.7
    forever begin
        clk_s = ~clk_s;
        #(T_CLKS/2);
    end
end


initial begin
    clk_d = 0;

    # 2
    forever begin
        clk_d = ~clk_d;
        #(T_CLKD/2);
    end

end


initial begin
    rstn_d = 0;

    # 123
    rstn_d = 1;
end


initial begin
    data_s = 0;

    repeat (30) begin
        # 1000;
        @ (posedge clk_s) begin
            data_s <= #`RD $random();
        end
    end

    # 1000;
    $finish();
end


async_ff #(
    .DW (DW),
    .TS (TS),
    .TH (TH)
) dut(
    .CP (clk_d  ),
    .CLR(rstn_d ),
    .D  (data_s ),
    .Q  (data_d )
);


endmodule
