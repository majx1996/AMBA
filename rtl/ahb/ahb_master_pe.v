`define     RD      1

module ahb_master_pe(
//----------------------
//      AHB
//------------------------
    ahb_if.master   ahb_if,

//----------------------
//      DMA
//------------------------
    dma_if.slave    dma_if
);


localparam ST_IDLE      = 3'b000 ; 
localparam ST_RD_NONSEQ = 3'b001 ; 
localparam ST_RD_SEQ    = 3'b010 ; 
localparam ST_WAIT_RD   = 3'b011 ; 
localparam ST_WR_NONSEQ = 3'b100 ; 
localparam ST_WR_SEQ    = 3'b101 ; 
localparam ST_WAIT_WR   = 3'b111 ; 

logic                       hclk      ; 
logic                       hresetn   ; 
logic [ADDR_WIDTH-1:0]      haddr     ; 
logic [2:0]                 hburst    ; 
logic                       hmastlock ; 
logic [3:0]                 hprot     ; 
logic [2:0]                 hsize     ; 
logic [1:0]                 htrans    ; 
logic [DATA_WIDTH-1:0]      hwdata    ; 
logic                       hwrite    ; 
logic [(DATA_WIDTH/8)-1:0]  hwstrb    ; 
logic [DATA_WIDTH-1:0]      hrdata    ; 
logic                       hreadyout ; 
logic                       hresp     ; 
logic                       hready    ; 

logic [2:0]                 cur_state ; 
logic [2:0]                 nex_state ; 

always @ (posedge hclk or negedge hresetn) begin
    if(~hresetn)
        cur_state <= #`RD '0;
    else
        cur_state <= #`RD nex_state;
end

always @ (*) begin
end


always @ (posedge hclk or negedge hresetn) begin
end


endmodule
