interface ahb_if #(
    parameter  ADDR_WIDTH = 32,
    parameter  DATA_WIDTH = 32
)(
    input  logic   HCLK,
    input  logic   HRESETn
);


logic [ADDR_WIDTH-1:0]      HADDR     ; 
logic [2:0]                 HBURST    ; 
logic                       HMASTLOCK ; 
logic [3:0]                 HPROT     ; 
logic [2:0]                 HSIZE     ; 
logic [1:0]                 HTRANS    ; 
logic [DATA_WIDTH-1:0]      HWDATA    ; 
logic                       HWRITE    ; 
logic [(DATA_WIDTH/8)-1:0]  HWSTRB    ;
logic [DATA_WIDTH-1:0]      HRDATA    ; 
logic                       HREADYOUT ; 
logic                       HRESP     ; 
logic                       HREADY    ; 


modport slave(
    input   HCLK      , 
    input   HRESETn   , 
    input   HADDR     , 
    input   HBURST    , 
    input   HMASTLOCK , 
    input   HPROT     , 
    input   HSIZE     , 
    input   HTRANS    , 
    input   HWDATA    , 
    input   HWRITE    , 
    input   HWSTRB    ,
    input   HREADYOUT , 
    output  HRDATA    , 
    output  HRESP     , 
    output  HREADY
);


modport master(
    input   HCLK      , 
    input   HRESETn   , 
    output  HADDR     , 
    output  HBURST    , 
    output  HMASTLOCK , 
    output  HPROT     , 
    output  HSIZE     , 
    output  HTRANS    , 
    output  HWDATA    , 
    output  HWRITE    , 
    output  HWSTRB    ,
    output  HREADYOUT , 
    input   HRDATA    , 
    input   HRESP     , 
    input   HREADY
);



endinterface
