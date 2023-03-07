`define     RD      1

module tb_top ();



localparam ADDR_WIDTH = 32;
localparam DATA_WIDTH = 32;

logic                           pclk_i       ; 
logic                           prstn_i      ; 
logic                           pready_i     ; 
logic [DATA_WIDTH-1:0]          prdata_i     ; 
logic                           pslverr_i    ; 
logic [ADDR_WIDTH-1:0]          reg_addr_i   ; 
logic [DATA_WIDTH-1:0]          reg_wdata_i  ; 
logic                           reg_enable_i ; 
logic                           reg_write_i  ; 
logic [ADDR_WIDTH-1:0]          paddr_o      ; 
logic [2:0]                     pport_o      ; 
logic                           psel_o       ; 
logic                           penable_o    ; 
logic                           pwrite_o     ; 
logic [DATA_WIDTH-1:0]          pwdata_o     ; 
logic [(DATA_WIDTH/8)-1:0]      pstrb_o      ; 
logic [DATA_WIDTH-1:0]          reg_rdata_o  ; 
logic                           reg_idle_o   ; 


apb_master #(
    .ADDR_WIDTH (ADDR_WIDTH),
    .DATA_WIDTH (DATA_WIDTH)
) dut(
    // Outputs
    .paddr_o                          (paddr_o[ADDR_WIDTH-1:0]     ), 
    .pport_o                          (pport_o[2:0]                ), 
    .psel_o                           (psel_o                      ), 
    .penable_o                        (penable_o                   ), 
    .pwrite_o                         (pwrite_o                    ), 
    .pwdata_o                         (pwdata_o[DATA_WIDTH-1:0]    ), 
    .pstrb_o                          (pstrb_o[(DATA_WIDTH/8)-1:0] ), 
    .reg_rdata_o                      (reg_rdata_o[DATA_WIDTH-1:0] ), 
    .reg_idle_o                       (reg_idle_o                  ), 
    // Inputs
    .pclk_i                           (pclk_i                      ), 
    .prstn_i                          (prstn_i                     ), 
    .pready_i                         (pready_i                    ), 
    .prdata_i                         (prdata_i[DATA_WIDTH-1:0]    ), 
    .pslverr_i                        (pslverr_i                   ), 
    .reg_addr_i                       (reg_addr_i[ADDR_WIDTH-1:0]  ), 
    .reg_wdata_i                      (reg_wdata_i[DATA_WIDTH-1:0] ), 
    .reg_enable_i                     (reg_enable_i                ), 
    .reg_write_i                      (reg_write_i                 )
);

// System Site
initial begin
    pclk_i      = 1'b0; 
    forever begin
        pclk_i  = ~pclk_i;
        # 3;
    end 
end

initial begin
    prstn_i     = 1'b0; 
    # 123
    prstn_i     = 1'b1;
end

// SoC Site
initial begin
    reg_addr_i   = 0 ;
    reg_wdata_i  = 0 ; 
    reg_enable_i = 0 ; 
    reg_write_i  = 0 ; 
    soc_write_data(32'hdeadbeaf, 32'h12345678);
    soc_write_data(32'hdeadbeaf, 32'h12345678);
    soc_read_data(32'hdeadbeaf);
    soc_read_data(32'hdeadbeaf);
    #100;
    $finish();
end

// Slave Site
initial begin
    pready_i     = 0 ; 
    prdata_i     = 32'hdeadbeaf ; 
    pslverr_i    = 0 ;
    forever begin
        slave_react();
    end
end


task slave_react;
    bit random_flag = 1;

    @ (posedge pclk_i) begin
        if(penable_o) begin
            while (random_flag) begin
                @(posedge pclk_i);
                random_flag = 0;
            end
            #`RD;
            prdata_i = $random();
            pready_i = 1'b1;
            @(posedge pclk_i);
            # `RD;
            pready_i = 1'b0;
        end
    end

endtask


task soc_write_data;
    input   [ADDR_WIDTH-1:0]    wr_addr;
    input   [DATA_WIDTH-1:0]    wr_data;

    bit wait_write;

    // wait FSM idle
    wait_write = 1'b1;
    while(wait_write) begin
        @(posedge pclk_i);
        if (reg_idle_o) begin
            wait_write = 1'b0;
        end
    end // while

    // push address
    repeat (5) begin
        @(posedge pclk_i);
    end
    @(posedge pclk_i) begin
        #`RD;
        reg_addr_i = wr_addr;
    end

    // push write data
    repeat (5) begin
        @(posedge pclk_i);
    end
    @(posedge pclk_i) begin
        #`RD;
        reg_wdata_i = wr_data;
    end

    // assert enable & write
    repeat (5) begin
        @(posedge pclk_i);
    end
    @(posedge pclk_i) begin
        #`RD;
        reg_write_i = 1'b1;
        reg_enable_i = 1'b1;
    end

    // deassert enable & write
    repeat (5) begin
        @(posedge pclk_i);
    end
    @(posedge pclk_i) begin
        #`RD;
        reg_write_i = 1'b0;
        reg_enable_i = 1'b0;
    end
endtask 


task soc_read_data;
    input   [ADDR_WIDTH-1:0]    rd_addr;

    bit wait_read;

    // wait FSM idle
    wait_read = 1'b1;
    while(wait_read) begin
        @(posedge pclk_i);
        if (reg_idle_o) begin
            wait_read = 1'b0;
        end
    end // while

    // push address
    repeat (5) begin
        @(posedge pclk_i);
    end
    @(posedge pclk_i) begin
        #`RD;
        reg_addr_i      = rd_addr;
    end

    // assert enable & deassert write
    repeat (5) begin
        @(posedge pclk_i);
    end
    @(posedge pclk_i) begin
        #`RD;
        reg_write_i     = 1'b0;
        reg_enable_i    = 1'b1;
    end

    // deassert enable
    repeat (5) begin
        @(posedge pclk_i);
    end
    @(posedge pclk_i) begin
        #`RD;
        reg_enable_i    = 1'b0;
    end

    // wait read data returned
    wait_read = 1'b1;
    while(wait_read) begin
        @(posedge pclk_i);
        if (reg_idle_o) begin
            wait_read = 1'b0;
        end
    end // while

    // show results
    $display("//---------------------------------------------------");
    $display("//            Rdata is 32'h%h", reg_rdata_o           );
    $display("//---------------------------------------------------");
endtask 


endmodule
