interface apb_if #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32);

logic   [ADDR_WIDTH-1:0]         paddr   ; 
logic   [2:0]                    pport   ; 
logic                            psel    ; 
logic                            penable ; 
logic                            pwrite  ; 
logic   [DATA_WIDTH-1:0]         pwdata  ; 
logic   [(DATA_WIDTH/8)-1:0]     pstrb   ; 
logic                            pready  ; 
logic   [DATA_WIDTH-1:0]         prdata  ; 
logic                            pslverr ; 

modport slv (
    input       paddr,
    input       pport,
    input       psel,
    input       penable,
    input       pwrite,
    input       pwdata,
    input       pstrb,
    output      pready,
    output      prdata,
    output      pslverr
);

modport mst (
    output      paddr,
    output      pport,
    output      psel,
    output      penable,
    output      pwrite,
    output      pwdata,
    output      pstrb,
    input       pready,
    input       prdata,
    input       pslverr
);

endinterface
