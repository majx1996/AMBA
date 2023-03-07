`define     RD      1

module apb_master #(
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
    output [ADDR_WIDTH-1:0]         paddr_o,
    output [2:0]                    pport_o,
    output                          psel_o,
    output                          penable_o,
    output                          pwrite_o,
    output [DATA_WIDTH-1:0]         pwdata_o,
    output [(DATA_WIDTH/8)-1:0]     pstrb_o,
    input                           pready_i,
    input  [DATA_WIDTH-1:0]         prdata_i,
    input                           pslverr_i,

//----------------------
//      CSR
//------------------------
    input  [ADDR_WIDTH-1:0]         reg_addr_i,         // destination address
    input  [DATA_WIDTH-1:0]         reg_wdata_i,        // data you want to transmit to slave
    output [DATA_WIDTH-1:0]         reg_rdata_o,        // data read from slave
    input                           reg_enable_i,       // initiate a transfer, a pulse
    input                           reg_write_i,        // indicates current transfer is a read or write transfer
    output                          reg_idle_o          // indicates apb master FSM is idle to handle a new transfer
);


//----------------------
//  Do Not Support
//------------------------
wire _unused_ok;

assign _unused_ok = &{
    pslverr_i, 
1'b0};

assign pport_o = 3'b000;                    // normal, secure, data
assign pstrb_o = {(DATA_WIDTH/8){1'b1}};    // all data lanes are valid


//----------------------
//      FSM
//------------------------
localparam  IDLE    = 2'b00;
localparam  SETUP   = 2'b01;
localparam  ACCESS  = 2'b10;

logic [1:0]             state;
logic [ADDR_WIDTH-1:0]  paddr;
logic                   psel;
logic                   penable;
logic                   pwrite;
logic [DATA_WIDTH-1:0]  pwdata;
logic [DATA_WIDTH-1:0]  reg_rdata;
logic                   reg_enable_d0;
logic                   reg_enable_pos;

assign reg_enable_pos = reg_enable_i && ~reg_enable_d0;
assign reg_idle_o  = (state == IDLE);
assign reg_rdata_o = reg_rdata ; 
assign paddr_o     = paddr     ; 
assign psel_o      = psel      ; 
assign penable_o   = penable   ; 
assign pwrite_o    = pwrite    ; 
assign pwdata_o    = pwdata    ; 


always @ (posedge pclk_i or negedge prstn_i) begin
    if(~prstn_i) begin
        reg_enable_d0 <= #`RD 1'b0;
    end else begin
        reg_enable_d0 <= #`RD reg_enable_i;
    end
end


always @ (posedge pclk_i or negedge prstn_i) begin
    if(~prstn_i) begin
        state       <= #`RD IDLE;
        paddr       <= #`RD '0;
        psel        <= #`RD '0;
        penable     <= #`RD '0;
        pwrite      <= #`RD '0;
        pwdata      <= #`RD '0;
        reg_rdata   <= #`RD '0;
    end else begin
        case(state)
            IDLE: begin

                if(reg_enable_pos) begin
                    state       <= #`RD SETUP;
                    paddr       <= #`RD reg_addr_i;
                    psel        <= #`RD 1'b1;
                end else begin
                    state       <= #`RD IDLE;
                    psel        <= #`RD 1'b0;
                end

                if((reg_enable_pos) & (reg_write_i)) begin
                    pwdata      <= #`RD reg_wdata_i;
                    pwrite      <= #`RD 1'b1;
                end else if ((reg_enable_pos) & (~reg_write_i)) begin
                    pwrite      <= #`RD 1'b0;
                end else begin
                    pwrite      <= #`RD '0;
                    pwdata      <= #`RD '0;
                end
                    penable     <= #`RD 1'b0;
            end // IDLE

            SETUP: begin
                    state       <= #`RD ACCESS;
                    penable     <= #`RD 1'b1;
            end // SETUP

            ACCESS: begin
                if((pready_i) & (~reg_enable_pos)) begin
                    state       <= #`RD IDLE;
                    paddr       <= #`RD paddr;
                    psel        <= #`RD 1'b0;
                end else if((pready_i) & (reg_enable_pos)) begin
                    state       <= #`RD SETUP;
                    paddr       <= #`RD reg_addr_i;
                    psel        <= #`RD 1'b1;
                end

                if(pready_i) begin
                    penable     <= #`RD 1'b0;
                end

                if((pready_i) & (reg_enable_pos) & (reg_write_i)) begin
                    pwrite      <= #`RD 1'b1;
                    pwdata      <= #`RD reg_wdata_i;
                end else if((pready_i) & (reg_enable_pos) & (~reg_write_i)) begin
                    pwrite      <= #`RD 1'b0;
                end

                if(pready_i) begin
                    reg_rdata   <= #`RD prdata_i;
                end
            end // ACCESS
        endcase
    end
end



endmodule
