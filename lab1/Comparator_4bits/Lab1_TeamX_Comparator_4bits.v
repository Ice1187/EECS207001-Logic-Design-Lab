`timescale 1ns/1ps

module Comparator_4bits (a, b, a_lt_b, a_gt_b, a_eq_b);

input [4-1:0] a;
input [4-1:0] b;
output a_lt_b;
output a_gt_b;
output a_eq_b;

wire [4-1:0] eq, gt;
wire [4-1-1:0] leading_gt;

Eq_1bit eq0 (
  .a(a[0]),
  .b(b[0]),
  .out(eq[0])
);
Eq_1bit eq1 (
  .a(a[1]),
  .b(b[1]),
  .out(eq[1])
);
Eq_1bit eq2 (
  .a(a[2]),
  .b(b[2]),
  .out(eq[2])
);
Eq_1bit eq3 (
  .a(a[3]),
  .b(b[3]),
  .out(eq[3])
);

Gt_1bit gt0 (
  .a(a[0]),
  .b(b[0]),
  .out(gt[0])
);
Gt_1bit gt1 (
  .a(a[1]),
  .b(b[1]),
  .out(gt[1])
);
Gt_1bit gt2 (
  .a(a[2]),
  .b(b[2]),
  .out(gt[2])
);
Gt_1bit gt3 (
  .a(a[3]),
  .b(b[3]),
  .out(gt[3])
);

// eq
and and_eq_0 (a_eq_b, eq[0], eq[1], eq[2], eq[3]);

// gt
and and_gt_2 (leading_gt[2], eq[3], gt[2]);
and and_gt_1 (leading_gt[1], eq[3], eq[2], gt[1]);
and and_gt_0 (leading_gt[0], eq[3], eq[2], eq[1], gt[0]);
or  or_gt_0  (a_gt_b, gt[3], leading_gt[2], leading_gt[1], leading_gt[0]);

// lt
nor nor_lt_0 (a_lt_b, a_eq_b, a_gt_b);

endmodule


module Eq_1bit (out, a, b);

input a;
input b;
output out;

wire c, d;

or or0 (c, a, b);
nand nand0 (d, a, b);
nand nand1 (out, c, d);

endmodule


module Gt_1bit (out, a, b);

input a;
input b;
output out;

wire b_n;

not not0 (b_n, b);
and and0 (out, a, b_n);

endmodule