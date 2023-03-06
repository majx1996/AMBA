module async_ff #(
    parameter           DW  =   1,
    parameter shortreal TCK =   1,
    parameter shortreal TS  =   0.5,
    parameter shortreal TH  =   0.5
)(
    input               CP,
    input               CLR,
    input  [DW-1:0]     D,
    output [DW-1:0]     Q
);

logic           CP_rd;
logic           CP_delay;
logic [DW-1:0]  D_delay;
logic [DW-1:0]  D_setup;
logic [DW-1:0]  D_current;
logic [DW-1:0]  D_hold;
logic [DW-1:0]  Q_ff;
logic [3:0]     detected_counter;

assign #TS D_delay = D;
assign #TH CP_delay = CP;
assign #TCK CP_rd = CP;
assign Q = Q_ff;

always @ (posedge CP or negedge CLR) begin
    if (~CLR) begin
        D_setup <= {DW{1'b0}};
    end else begin
        D_setup <= D_delay;
    end
end

always @ (posedge CP or negedge CLR) begin
    if (~CLR) begin
        D_current <= {DW{1'b0}};
    end else begin
        D_current <= D;
    end
end

always @ (posedge CP_delay or negedge CLR) begin
    if (~CLR) begin
        D_hold <= {DW{1'b0}};
    end else begin
        D_hold <= D;
    end
end

integer i;
always @ (posedge CP_rd or negedge CLR) begin
    for (i = 0; i < DW; i = i + 1) begin
        if (~CLR) begin
            Q_ff[i] <= 1'b0;
        end else if ((D_current[i] == D_setup[i]) && (D_current[i] == D_hold[i])) begin
            Q_ff[i] <= D[i];
        end else begin
            Q_ff[i] <= 0;
            detect_metastability();
        end
    end
end

initial begin
    detected_counter = 0;
end

function detect_metastability; 
    begin
        if(detected_counter[3:0] <= 4'h1) begin
            $display("metastability detected at %m");
            detected_counter = detected_counter + 1;
        end
    end
endfunction



endmodule
