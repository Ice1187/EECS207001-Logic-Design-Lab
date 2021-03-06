`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);

// Traffic lights
parameter GREEN  = 3'b100;
parameter YELLOW = 3'b010;
parameter RED    = 3'b001;
parameter ERR_LIGHT = 3'b111;

// States
parameter HW_G = 3'd0;
parameter HW_G2Y = 3'd1;
parameter HW_Y = 3'd2;
parameter HW_R = 3'd3;
parameter LR_G = 3'd4;
parameter LR_Y = 3'd5;
parameter LR_R = 3'd6;
parameter ERR_STATE = 3'd7;

// IO ports
input clk, rst_n;
input lr_has_car;
output reg [3-1:0] hw_light;
output reg [3-1:0] lr_light;

// wire & reg
reg [3-1:0] state;
reg [3-1:0] next_state;
reg [6-1:0] timer;
reg [6-1:0] next_timer;


always @(posedge clk) begin
  if (rst_n == 1'b0) begin
    state <= HW_G;
    timer <= 6'b0;
  end
  else begin
    state <= next_state;
    timer <= next_timer;
  end
end


// Change state according to current 'state', 'timer' and 'lr_has_car'
always @(*) begin
  case (state)
    HW_G: begin
      if (timer == 6'd35 - 6'd1 - 6'd1)
      // if (timer == 6'd3 - 6'd1 - 6'd1)  // FIXME: test only
        // leave 1 cyc to 'HW_G2Y' state
        next_state = HW_G2Y;
      else
        next_state = HW_G;
     end
    HW_G2Y: begin
      if (lr_has_car == 1'b1)
        next_state = HW_Y;
      else
        next_state = HW_G2Y;
    end
    HW_Y: begin
      if (timer == 6'd15 - 6'd1)
      // if (timer == 6'd2 - 6'd1)  // FIXME: test only
        next_state = HW_R;
      else
        next_state = HW_Y;
    end
    HW_R: begin
      if (timer == 6'd1 - 6'd1)
        next_state = LR_G;
      else
        next_state = HW_R;
    end
    LR_G: begin
      if (timer == 6'd35 - 6'd1)
      // if (timer == 6'd3 - 6'd1)  // FIXME: test only
        next_state = LR_Y;
      else
        next_state = LR_G;
    end
    LR_Y: begin
      if (timer == 6'd15 - 6'd1)
      // if (timer == 6'd2 - 6'd1)  // FIXME: test only
        next_state = LR_R;
      else
        next_state = LR_Y;
    end
    LR_R: begin
      if (timer == 6'd1 - 6'd1)
        next_state = HW_G;
      else
        next_state = LR_R;
    end
    default: begin
      next_state = ERR_STATE;
    end
  endcase
end

// Change timer according to 'next_state'
always @(*) begin
  if (next_state != state)
    next_timer = 6'b0;
  else
    next_timer = timer + 6'b1;
end

// Assign 'hw_light'
always @(*) begin
  case (state)
    HW_G,
    HW_G2Y:
      hw_light = GREEN;
    HW_Y:
      hw_light = YELLOW;
    HW_R,
    LR_G,
    LR_Y,
    LR_R:
      hw_light = RED;
    default
      hw_light = ERR_LIGHT;
  endcase
end

// Assign 'lr_light'
always @(*) begin
  case (state)
    LR_G:
      lr_light = GREEN;
    LR_Y:
      lr_light = YELLOW;
    LR_R,
    HW_G,
    HW_G2Y,
    HW_Y,
    HW_R:
      lr_light = RED;
    default
      lr_light = ERR_LIGHT;
  endcase
end

endmodule
