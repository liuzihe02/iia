module tlc (
    input  wire       clk,
    input  wire       request,
    input  wire       reset,
    output reg  [4:0] \output   // {veh_G, veh_Y, veh_R, ped_G, ped_R}
);

  localparam G = 2'd0, Y = 2'd1, R = 2'd2;

  reg [ 1:0] state;
  reg [28:0] count;

  // Sequential: state transitions & timer
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      state <= G;
      count <= 29'd0;
    end else begin
      case (state)
        G: begin
          if (request == 1'b0) begin
            state <= Y;
            count <= 29'd0;
          end
        end
        Y: begin
          if (count == 29'd250_000_000) begin // 5s @ 50 MHz
            state <= R;
            count <= 29'd0;
          end else count <= count + 29'd1;
        end
        R: begin
          if (count == 29'd500_000_000) begin // 10s @ 50 MHz
            state <= G;
            count <= 29'd0;
          end else count <= count + 29'd1;
        end
        default: begin
          state <= G;
          count <= 29'd0;
        end
      endcase
    end
  end

  // Combinational: output mapping
  always @(*) begin
    case (state)
      G:       \output = 5'b10001;
      Y:       \output = 5'b01001;
      R:       \output = 5'b00110;
      default: \output = 5'b10001;
    endcase
  end

endmodule
