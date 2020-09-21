`timescale 1ns/1ps

/**
 *  
 *  Collect all lib/ modules into a single module for clearity.
 * 
*/
module LibCollect ();

// Cmp
reg eq_out, eq_a, eq_b;
reg ge_out, ge_a, ge_b;
reg gt_out, gt_a, gt_b;
reg le_out, le_a, le_b;
reg lt_out, lt_a, lt_b;

Eq_1bit (eq_out, eq_a, eq_b);
Ge_1bit (ge_out, ge_a, ge_b);
Gt_1bit (gt_out, gt_a, gt_b);
Le_1bit (le_out, le_a, le_b);
Lt_1bit (lt_out, lt_a, lt_b);

// FullAdder
reg fa_a, fa_b, fa_cin, fa_cout, fa_sum;
FullAdder (fa_sum, fa_cout, fa_a, fa_b, fa_cin);

// Mux


endmodule