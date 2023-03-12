`define     RD      1

module tb_top ();



localparam ADDR_WIDTH = 32;
localparam DATA_WIDTH = 32;


logic                           pclk_i       ; 
logic                           prstn_i      ; 
logic [ADDR_WIDTH-1:0]          reg_addr_i   ; 
logic [DATA_WIDTH-1:0]          reg_wdata_i  ; 
logic                           reg_enable_i ; 
logic                           reg_write_i  ; 
logic [DATA_WIDTH-1:0]          reg_rdata_o  ; 
logic                           reg_idle_o   ; 


apb_if #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) apb_if();


apb_master #(
    .ADDR_WIDTH (ADDR_WIDTH),
    .DATA_WIDTH (DATA_WIDTH)
) dut(
    // Interface
    .apb_if                           (apb_if                      ), 
    // Outputs
    .reg_rdata_o                      (reg_rdata_o[DATA_WIDTH-1:0] ), 
    .reg_idle_o                       (reg_idle_o                  ), 
    // Inputs
    .pclk_i                           (pclk_i                      ), 
    .prstn_i                          (prstn_i                     ), 
    .reg_addr_i                       (reg_addr_i[ADDR_WIDTH-1:0]  ), 
    .reg_wdata_i                      (reg_wdata_i[DATA_WIDTH-1:0] ), 
    .reg_enable_i                     (reg_enable_i                ), 
    .reg_write_i                      (reg_write_i                 ) 
);

apb_slave_smodel #(
    .ADDR_WIDTH (ADDR_WIDTH),
    .DATA_WIDTH (DATA_WIDTH)
) slave(
    // Interface
    .apb_if                         (apb_if       ), 
    // Inputs
    .pclk_i                         (pclk_i       ), 
    .prstn_i                        (prstn_i      ), 
    .reg_addr_high_i                (32'h5000FFFF ), 
    .reg_addr_low_i                 (32'h50002000 ) 
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
    // Invalid Address
    soc_write_data(32'hdeadbeaf, 32'h12345678);
    soc_write_data(32'hdeadbeaf, 32'h12345678);
    // Valid Address
    soc_write_data(32'h50003FFF, 32'hdeadbeaf);
    soc_write_data(32'h5000701C, 32'h87654321);
    soc_write_data(32'h50002000, 32'h12345678);
    soc_write_data(32'h5000FFFF, 32'h21436587);
    // Invalid Address
    soc_read_data(32'hdeadbeaf);
    soc_read_data(32'h12345678);
    // Valid Address
    soc_read_data(32'h5000401C);
    soc_read_data(32'h50002000);
    soc_read_data(32'h5000FFFF);
    #100;
    $finish();
end


task soc_write_data;
    input   [ADDR_WIDTH-1:0]    wr_addr;
    input   [DATA_WIDTH-1:0]    wr_data;

    bit wait_write;

    $display("\n\n//---------------------------------------------------"                            );
    $display("// Simulation time: %t", $time()                                                      );
    $display("// Initiate a write transfer with address of 0x%H and data of 0x%H", wr_addr, wr_data );
    $display("//---------------------------------------------------"                                );

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

    $display("\n\n//---------------------------------------------------");
    $display("// Simulation time: %t", $time()                          );
    $display("// Initiate a read transfer with address of 0x%H", rd_addr);
    $display("//---------------------------------------------------"    );

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
    $display("// Simulation time: %t", $time()                      );
    $display("//    Rdata is 0x%H", reg_rdata_o                     );
    $display("//---------------------------------------------------");
endtask 


endmodule
