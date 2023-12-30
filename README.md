# FPGA VGA Display

## Project Overview

This project involves creating a VGA display controller, a seven-segment display module, and a debounce circuit. The integrated system showcases various visual patterns and movements on the VGA display based on mode selection and user input.

## Modules

### VGA Display Controller

- **File:** `vga_display.v`
- **Description:** This module defines the VGA display controller responsible for generating visual patterns and movements on the Basys 3 Artix-7 Development Board's VGA display.

### Seven-Segment Display

- **File:** `seven_seg.v`
- **Description:** The seven-segment display module (`seven_seg`) controls a four-digit seven-segment display, showcasing values in hexadecimal digits.

### Debounce Circuit

- **File:** `debounce.v`
- **Description:** The `debounce` module implements a simple debounce circuit to remove noise and glitches from input signals, particularly useful for buttons and switches.

## How to Use

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/ece3829_lab2.git
   ```

2. Open the project files in your Verilog development environment (e.g., Vivado).

3. Simulate or synthesize the modules based on your specific development environment.

4. Upload the bitstream to the Basys 3 Artix-7 Development Board.

5. Observe the visual patterns and movements on the VGA display based on the mode selection and user input.

## Dependencies

- Verilog 2021.1
- Basys 3 Artix-7 Development Board
