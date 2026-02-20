// ============================================================================
// Traffic Light Controller (TLC) for Pedestrian Crossing
// ============================================================================
// Implements a 3-state FSM for a pedestrian light-controlled crossing.
//
// FSM states:
//   State G (initial) - vehicle GREEN,  pedestrian RED
//   State Y           - vehicle YELLOW, pedestrian RED   (transitional)
//   State R           - vehicle RED,    pedestrian GREEN
//
// Behaviour:
//   - Initial state: State G (vehicle GREEN, pedestrian RED)
//   - On pedestrian request: State G -> State Y (5s) -> State R (10s) -> State G
//   - Reset returns to State G at any time
//
// Target: DE1-SoC board (Cyclone V FPGA) with 50 MHz clock
// Output mapping: {veh_GREEN, veh_YELLOW, veh_RED, ped_GREEN, ped_RED}
// ============================================================================

module tlc (
    input wire clk,  // 50 MHz on-board clock (PIN_AF14)
    input wire request,  // Pedestrian push-button (active LOW on DE1-SoC)
    input wire reset,  // Reset push-button (active LOW, asynchronous)
    output reg [4:0] \output // 5-bit output: {veh_GREEN, veh_YELLOW, veh_RED, ped_GREEN, ped_RED}
);

  // --- State encoding (2-bit) ---
  // Only 3 states needed, so 2 bits suffice
  localparam G = 2'd0;  // State G: vehicle GREEN  / pedestrian RED
  localparam Y = 2'd1;  // State Y: vehicle YELLOW / pedestrian RED
  localparam R = 2'd2;  // State R: vehicle RED    / pedestrian GREEN

  reg [ 1:0] state;  // Current FSM state
  reg [28:0] count;  // 29-bit counter for timing delays
                     // 29 bits can count up to 2^29 - 1 = 536,870,911
                     // which is enough for 500,000,000 (10s @ 50 MHz)

  // ========================================================================
  // Sequential logic: state transitions & timer
  // ========================================================================
  // Triggered on rising clock edge OR falling edge of reset (async reset).
  // DE1-SoC push-buttons are active LOW, so reset triggers on negedge.
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      // --- Asynchronous reset: return to State G ---
      state <= G;
      count <= 29'd0;
    end else begin
      case (state)

        // --- State G: wait for pedestrian request ---
        // request is active LOW (button pressed = 0), so we check == 0.
        // No timer; we stay in State G indefinitely until request.
        G: begin
          if (request == 1'b0) begin
            state <= Y;
            count <= 29'd0;
          end
        end

        // --- State Y: vehicle YELLOW for 5 seconds ---
        // 5 seconds @ 50 MHz = 250,000,000 clock cycles.
        Y: begin
          if (count == 29'd250_000_000) begin
            state <= R;
            count <= 29'd0;
          end else begin
            count <= count + 29'd1;
          end
        end

        // --- State R: vehicle RED, pedestrian GREEN for 10 seconds ---
        // 10 seconds @ 50 MHz = 500,000,000 clock cycles.
        R: begin
          if (count == 29'd500_000_000) begin
            state <= G;
            count <= 29'd0;
          end else begin
            count <= count + 29'd1;
          end
        end

        // --- Default: safety fallback to State G ---
        // Catches undefined states (e.g. state = 2'd3)
        default: begin
          state <= G;
          count <= 29'd0;
        end
      endcase
    end
  end

  // ========================================================================
  // Combinational logic: output assignment
  // ========================================================================
  // Maps each state to the 5-bit LED output vector:
  //   Bit [4] = veh_GREEN
  //   Bit [3] = veh_YELLOW
  //   Bit [2] = veh_RED
  //   Bit [1] = ped_GREEN
  //   Bit [0] = ped_RED
  //
  //   State G: veh_GREEN on,  ped_RED on   -> 10001
  //   State Y: veh_YELLOW on, ped_RED on   -> 01001
  //   State R: veh_RED on,    ped_GREEN on -> 00110
  always @(*) begin
    case (state)
      G:       \output = 5'b10001;
      Y:       \output = 5'b01001;
      R:       \output = 5'b00110;
      default: \output = 5'b10001;  // Default to State G
    endcase
  end

endmodule
