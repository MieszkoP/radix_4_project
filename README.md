Projekt uses a TCL script.
1. Open Vivado
2. Tools -> Run TCL Script...
3. Select the TCL file project.tcl

How algorithm operates:

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

![DiagramStanow_sekw](https://github.com/user-attachments/assets/2ff4a36c-2310-4e3c-a1d4-f7cc359c312f)
