`define     RD      1

module apb_slave_smodel #(
    parameter                       ADDR_WIDTH  = 32,
    parameter                       DATA_WIDTH  = 32
)(

//----------------------
//      System
//------------------------
    input                           pclk_i,
    input                           prstn_i,

//----------------------
//      APB
//------------------------
    input  [ADDR_WIDTH-1:0]         paddr_i,
    input  [2:0]                    pport_i,
    input                           psel_i,
    input                           penable_i,
    input                           pwrite_i,
    input  [DATA_WIDTH-1:0]         pwdata_i,
    input  [(DATA_WIDTH/8)-1:0]     pstrb_i,
    output                          pready_o,
    output [DATA_WIDTH-1:0]         prdata_o,
    output                          pslverr_o,

//----------------------
//      CSR
//------------------------
    input  [ADDR_WIDTH-1:0]         reg_addr_high_i,
    input  [ADDR_WIDTH-1:0]         reg_addr_low_i
);

//----------------------
//  Do Not Support
//------------------------
assign pslverr_o = 1'b0;

//----------------------
//      React
//------------------------
logic                   pready;
logic [DATA_WIDTH-1:0]  prdata;
logic                   random_done;


assign pready_o = pready;
assign prdata_o = prdata;


always @ (posedge pclk_i or negedge prstn_i) begin
    if(~prstn_i)
        pready  <= #`RD 1'b0;
    else if (psel_i & pwrite_i & random_done)
        pready  <= #`RD 1'b1; 
    else if (psel_i & ~pwrite_i & random_done)
        pready  <= #`RD 1'b1;
    else 
        pready  <= #`RD 1'b0;
end

always @ (posedge pclk_i or negedge prstn_i) begin
    if(~prstn_i) begin
        prdata  <= #`RD '0;
    end else if (pready & penable_i & pwrite_i) begin
        $display("Simulation time: %t, Slave %m receives data: 0x%H", $time(), pwdata_i);
    end else if (pready & penable_i & ~pwrite_i) begin
        prdata <= #`RD $random(seed);
        $display("Simulation time: %t, Slave %m transmits data: 0x%H", $time(), prdata_o);
    end
end

always @ (posedge pclk_i or negedge prstn_i) begin
    if(((pready & penable_i)) && (paddr_i <= reg_addr_high_i) && (paddr_i >= reg_addr_low_i)) begin
        $display("Simulation time: %t, Slave %m receives a transfer with address of 0x%H", $time(), paddr_i);
    end else if (pready & penable_i) begin
        $display("Simulation time: %t, Slave %m receives a transfer with address of 0x%H", $time(), paddr_i);
    end
end

// Random
bit [31:0] seed;

initial begin
    if(!$value$plusargs("seed=%d", seed))
        seed = 0;
    $display("Random seed is %d", seed);
end

initial begin
    random_done = 0;

    forever begin
        @ (posedge pclk_i) #`RD random_done = $random(seed);
    end
end

endmodule
