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
    apb_if.slv                      apb_if,

//----------------------
//      CSR
//------------------------
    input  [ADDR_WIDTH-1:0]         reg_addr_high_i,
    input  [ADDR_WIDTH-1:0]         reg_addr_low_i
);

//----------------------
//  Do Not Support
//------------------------
assign apb_if.pslverr = 1'b0;

//----------------------
//      React
//------------------------
logic                   pready;
logic [DATA_WIDTH-1:0]  prdata;
logic                   random_done;


assign apb_if.pready = pready;
assign apb_if.prdata = prdata;


always @ (posedge pclk_i or negedge prstn_i) begin
    if(~prstn_i)
        pready  <= #`RD 1'b0;
    else if (apb_if.psel & apb_if.pwrite & random_done)
        pready  <= #`RD 1'b1; 
    else if (apb_if.psel & ~apb_if.pwrite & random_done)
        pready  <= #`RD 1'b1;
    else 
        pready  <= #`RD 1'b0;
end

always @ (posedge pclk_i or negedge prstn_i) begin
    if(~prstn_i) begin
        prdata  <= #`RD '0;
    end else if (apb_if.pready & apb_if.penable & apb_if.pwrite) begin
        $display("Simulation time: %t, Slave %m receives data: 0x%H", $time(), apb_if.pwdata);
    end else if (apb_if.pready & apb_if.penable & ~apb_if.pwrite) begin
        prdata <= #`RD $random(seed);
        $display("Simulation time: %t, Slave %m transmits data: 0x%H", $time(), apb_if.prdata);
    end
end

always @ (posedge pclk_i or negedge prstn_i) begin
    if(((apb_if.pready & apb_if.penable)) && (apb_if.paddr <= reg_addr_high_i) && (apb_if.paddr >= reg_addr_low_i)) begin
        $display("Simulation time: %t, Slave %m receives a transfer with address of 0x%H", $time(), apb_if.paddr);
    end else if (apb_if.pready & apb_if.penable) begin
        $display("Simulation time: %t, Slave %m receives a transfer with address of 0x%H", $time(), apb_if.paddr);
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
