analyze -sv Multiplier.v

elaborate -top Multiplier

clock clk
reset rst

# productDone is high 7-11 clock cycles after start is high
assert {rst |-> ##[7:11] productDone};

# if both nonnegative, product is nonnegative
assert {multiplierReg[3]==0 && multiplicandReg[3]==0 && productDone -> product[7]==0}

# if multiplier positive and multiplicand negative, product is negative
assert {multiplierReg[3] == 0 && multiplierReg != 0 && multiplicandReg[3]==1}

# if both negative, product is nonnegative
assert {multiplierReg[3]==1 && multiplicandReg[3]==1 && productDone -> product[7]==0}

prove -all