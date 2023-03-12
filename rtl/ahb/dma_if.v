interface dma_if #(
    parameter   ADDR_WIDTH = 32,
    parameter   DATA_WIDTH = 32
)();


localparam BWIDTH = $clog2(((DATA_WIDTH / 8) * 16));


logic                   dma_en        ; 
logic [ADDR_WIDTH-1:0]  dma_dst_addr  ; 
logic [ADDR_WIDTH-1:0]  dma_src_addr  ; 
logic                   dma_start     ; 
logic                   dma_done      ; 
logic                   dma_busy      ; 
logic [BWIDTH-1:0]      dma_bnum      ; 
logic                   dma_enincr4   ; 
logic                   dma_enincr8   ; 
logic                   dma_enincr16  ; 
logic                   dma_rdata_en  ; 
logic [DATA_WIDTH-1:0]  dma_rdata     ; 
logic                   dma_rdata_vld ; 


modport slave(
    input   dma_en        , 
    input   dma_dst_addr  , 
    input   dma_src_addr  , 
    input   dma_start     , 
    input   dma_bnum      , 
    input   dma_enincr4   , 
    input   dma_enincr8   , 
    input   dma_enincr16  , 
    input   dma_rdata_en  , 
    output  dma_done      , 
    output  dma_busy      , 
    output  dma_rdata     , 
    output  dma_rdata_vld  
);


modport master(
    output  dma_en        , 
    output  dma_dst_addr  , 
    output  dma_src_addr  , 
    output  dma_start     , 
    output  dma_bnum      , 
    output  dma_enincr4   , 
    output  dma_enincr8   , 
    output  dma_enincr16  , 
    output  dma_rdata_en  , 
    input   dma_done      , 
    input   dma_busy      , 
    input   dma_rdata     , 
    input   dma_rdata_vld  
);



endinterface
