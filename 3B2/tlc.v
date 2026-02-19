// ============================================================================
// Traffic Light Controller (TLC) for Pedestrian Crossing
// ============================================================================
// Implements a 3-state FSM for a pedestrian light-controlled crossing:
//   - Initial state: vehicle GREEN, pedestrian RED
//   - On pedestrian request: GREEN -> YELLOW (5s) -> RED (10s) -> GREEN
//   - Reset returns to initial state at any time
//
// Target: DE1-SoC board (Cyclone V FPGA) with 50 MHz clock
// Output mapping: {veh_GREEN, veh_YELLOW, veh_RED, ped_GREEN, ped_RED}
// ============================================================================

module tlc (
    input  wire       clk,      // 50 MHz on-board clock (PIN_AF14)
    input  wire       request,  // Pedestrian push-button (active LOW on DE1-SoC)
    input  wire       reset,    // Reset push-button (active LOW, asynchronous)
    output reg  [4:0] \output   // 5-bit output driving LEDs for vehicle & pedestrian lights
);

  // --- State encoding (2-bit) ---
  // Only 3 states needed, so 2 bits suffice
  localparam G = 2'd0;  // Vehicle GREEN  / Pedestrian RED
  localparam Y = 2'd1;  // Vehicle YELLOW / Pedestrian RED  (transitional)
  localparam R = 2'd2;  // Vehicle RED    / Pedestrian GREEN

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
      // --- Asynchronous reset: return to initial state ---
      state <= G;
      count <= 29'd0;
    end else begin
      case (state)

        // --- GREEN state: wait for pedestrian request ---
        // request is active LOW (button pressed = 0), so we check == 0.
        // No timer here; we stay in GREEN indefinitely until request.
        G: begin
          if (request == 1'b0) begin
            state <= Y;  // Transition to YELLOW
            count <= 29'd0;  // Reset counter for YELLOW timing
          end
        end

        // --- YELLOW state: vehicle yellow for 5 seconds ---
        // 5 seconds @ 50 MHz = 250,000,000 clock cycles.
        // Counter increments each cycle until threshold is reached.
        Y: begin
          if (count == 29'd250000000) begin
            state <= R;  // Transition to RED
            count <= 29'd0;  // Reset counter for RED timing
          end else begin
            count <= count + 29'd1;
          end
        end

        // --- RED state: vehicle red + pedestrian green for 10 seconds ---
        // 10 seconds @ 50 MHz = 500,000,000 clock cycles.
        // After timeout, return to GREEN (initial state).
        R: begin
          if (count == 29'd500000000) begin
            state <= G;  // Return to initial state
            count <= 29'd0;
          end else begin
            count <= count + 29'd1;
          end
        end

        // --- Default: safety fallback to GREEN ---
        // Catches any undefined states (e.g. state = 2'd3)
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
  //   Bit [4] = vehicle GREEN
  //   Bit [3] = vehicle YELLOW
  //   Bit [2] = vehicle RED
  //   Bit [1] = pedestrian GREEN
  //   Bit [0] = pedestrian RED
  //
  // State G: vehicle GREEN on,  pedestrian RED on   -> 10001
  // State Y: vehicle YELLOW on, pedestrian RED on   -> 01001
  // State R: vehicle RED on,    pedestrian GREEN on -> 00110
  always @(*) begin
    case (state)
      G:       \output = 5'b10001;
      Y:       \output = 5'b01001;
      R:       \output = 5'b00110;
      default: \output = 5'b10001;  // Default to safe GREEN state
    endcase
  end

endmodule
