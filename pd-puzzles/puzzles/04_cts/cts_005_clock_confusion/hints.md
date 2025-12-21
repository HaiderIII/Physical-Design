# Hints for CTS_005: Clock Confusion

## Hint 1: Understanding the Error
The warning `port 'CLK' not found` means the SDC file is trying to create a clock on a port named "CLK", but no such port exists in the design.

## Hint 2: Case Sensitivity
Verilog port names are case-sensitive. A port named `clk` is different from `CLK`. Check both the Verilog design and the SDC constraints file.

## Hint 3: Check the Verilog Port Name
Look at line 9 of `resources/pipelined_adder.v`:
```verilog
input  wire        clk,
```
The clock port is lowercase `clk`.

## Hint 4: Check the SDC Clock Definition
Look at the `create_clock` command in `resources/constraints.sdc`:
```tcl
create_clock -name CLK -period 2.0 [get_ports CLK]
```
It uses uppercase `CLK`.

## Hint 5: The Fix
Change the SDC file to use the correct port name:
```tcl
create_clock -name clk -period 2.0 [get_ports clk]
set_input_delay -clock clk 0.3 [get_ports {a[*] b[*] valid_in op_mode[*]}]
set_output_delay -clock clk 0.3 [get_ports {result[*] valid_out carry_out overflow}]
```

## Common Causes of This Bug

1. **Copy-paste from other designs**: Clock naming conventions differ between projects
2. **Case sensitivity confusion**: Some tools are case-insensitive, others are not
3. **Generated SDC templates**: Auto-generated constraints may use generic names
4. **IP integration**: Blocks from different teams may use different conventions

## Prevention Tips

1. Use consistent naming conventions across your flow
2. Add `get_ports` validation in your SDC scripts
3. Use linting tools to check SDC-to-Verilog consistency
4. Create flow checks that verify clock nets are found after CTS
