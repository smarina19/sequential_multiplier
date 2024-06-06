// productDone is high 7-11 clock cycles after start is high
assert {start |-> ##[7:11] productDone};

// if both nonnegative, product is nonnegative
assert {multiplier[3]==0 && multiplicand[3]==0 && productDone -> product[7]==0}

// if multiplier positive and multiplicand negative, product is negative
assert {multiplier[3] == 0 && multiplier != 0 && multiplicand[3]==1}

// if both negative, product is nonnegative
assert {multiplier[3]==1 && multiplicand[3]==1 && productDone -> product[7]==0}