analyze -sv Multiplier.v

elaborate -top Multiplier

clock clk
reset rst

# productDone is high 7-11 clock cycles after start is high
assert {rst |-> ##[7:11] productDone};

# if both nonnegative, product is nonnegative
assert {multiplierReg[3]==0 && multiplicandReg[7]==0 && productDone -> product[8]==0}

# if multiplier positive and multiplicand negative, product is negative
assert {multiplierReg[3] == 0 && multiplierReg != 0 && multiplicandReg[3]==1 && productDone -> product[8]==1}

# if both negative, product is nonnegative
assert {multiplierReg[3]==1 && multiplicandReg[7]==1 && productDone -> product[8]==0}

#result should always be 

#if at least one number is even the product should be even
assert {((multiplierReg) % 2) == 0 && ((multiplicandReg) % 2) != 0 && productDone -> ((product) % 2) ==0}

#if both even the product should be even
assert {((multiplierReg) % 2) == 0 && ((multiplicandReg) % 2) == 0 && productDone -> (product % 2) ==0}

#if both odd the product should be odd
assert {((multiplierReg) % 2) != 0 && ((multiplicandReg) % 2) != 0 && productDone -> ((product) % 2) !=0}



prove -all