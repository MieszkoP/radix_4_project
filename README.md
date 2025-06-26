# Booth multiplier on FPGA with build-in soft test
This project implements the Booth multiplication algorithm with Buil-in Soft Test in Verilog. 
Block diagram of modules in project:
![BIST](https://github.com/user-attachments/assets/ef2e0755-206e-4942-94ae-832ed4462da7)

Booth multiplication with Radix-4 encoding allows to shorten the number of operations by grouping the bits of the multiplicand and analyzing their values ​​in triples. Based on these triples, the appropriate partial products are determined, which can be equal to -2x, -x, 0, x or 2x. These products are then appropriately shifted and summed, which leads to obtaining the final result of multiplication
## Run...

### If you want to see simulation files:
1. Open Vivado
2. Tools -> Run TCL Script...
3. Select the TCL file project_3.tcl (
4. Necessery files should open

### If you want to synthezise bitstream and upload data to Zedboard (with Zynq-7000 and ARM):
1. Open Vivado
2. Tools -> Run TCL Script...
3. Select the TCL file project_3_zynq.tcl
4. Create AXI4 IP proj5.ect
5. Copy content from src/CopyToAXI.txt file
6. Re-Package IP
7. Create block design with Zynq and new IP core
8. Run synthesis, implementation and bitstream. 

## Booth mulitiplication algorithm - comparison between two of them

The algorithm is implemented in two different ways. The second one requires fewer states but more complex operations. The first algorithm is in the file "radix_4.v", and the second in "radix_4_lut.v".

### Algorithm 1:

```text
Radix_4_multiplier(8bit x, 8bit y)
  9bit x' = x<<1, x[LSB] = 0;
  FOR i FROM 0 TO 5 DO
      partial_product = y<<2*i;
      IF(x'[2*i] == x'[2*i+1] ==x'[2*i+2]) -> continue (pomiń tę iteracje fora)
      IF(x'[2*i+2] == 1) -> partial_product := -partial_product
      IF(x'[2*i+1] == x'[2*i]) -> partial_product := 2*partial_product (czyli przesunięcie o 1 bit w lewo)
      sum+=partial_product;
  ENDFOR
  return suma;

```

### Algorithm 2:
```text
Radix_4_multiplier(8bit x, 8bit y)
  9bit x' = x<<1, x[LSB] = 0;
  FOR i FROM 0 TO 4 DO
      partial_product = y<<2*i
      partial_product := partial_product * Multiply_lut(x'[2*i], x'[2*i+1], x'[2*i+2]) 
      sum+=partial_product;
  ENDFOR
  return suma;
```

### Algorithm 1 State Machine:
![state_machine_radix](https://github.com/user-attachments/assets/f3b376c9-b5d4-4b76-9983-f86e7dcf9e1b)

### Algorithm 2 State Machine:
![state_machine_lut](https://github.com/user-attachments/assets/b5692252-abe9-4717-a228-5b911b443766)


### Tabela: Comparison of Two Algorithm Implementations
After generating IP core and running implementation, here how properties of algorthitms in FPGA looks like:

| Parameter                                                     |  Algorithm 1       | Algorithm 2 (with `case`)     |
|---------------------------------------------------------------|-------------------------------|--------------------------------------|
| Worst Negative Slack                                          | 4.318 ns                      | 4.290 ns                             |
| Number of Registers (global)                                  | 690                           | 691                                  |
| Number of Slices (global)                                     | 198                           | 206                                  |
| Number of LUTs (global)                                       | 540                           | 567                                  |
| Number of LUTs used as memory (global)                        | 60                            | 60                                   |
| Number of LUTs used as logic (global)                         | 480                           | 507                                  |
| Number of Slices in BIST module                               | 44                            | 51                                   |
| Number of LUTs in BIST module                                 | 138                           | 166                                  |
| Number of LUTs used as memory in BIST module                  | 0                             | 0                                    |
| Number of LUTs used as logic in BIST module                   | 138                           | 166                                  |
| Number of Slices in multiplier module                         | 27                            | 35                                   |
| Number of LUTs in multiplier module                           | 87                            | 123                                  |
| Number of LUTs used as memory in multiplier module            | 0                             | 0                                    |
| Number of LUTs used as logic in multiplier module             | 87                            | 123                                  |

## Build-in Soft Test

Bist test generates pseudo-random values ​​at the input (in this case, these are the factors x and y, which are multiplied), pass through the tested system, and then the sequence of results goes to the signature generator. If the system works as it should, the pseudo-random vector generator generates the same test vectors every time, which leads to the same sequence at the output and the same signature. If the system is damaged or the algorithm changes, then the sequence of results and thus the signature will change.

Signature generator: https://github.com/MieszkoP/radix_4_project/blob/main/src/misr.v
Test vector generator: https://github.com/MieszkoP/radix_4_project/blob/main/src/generator.v

## Firmware

The binary file should be compiled using the GCC compiler from the source files in the 'srcFirmware' directory and then flashed to the ARM processor on the ZedBoard
