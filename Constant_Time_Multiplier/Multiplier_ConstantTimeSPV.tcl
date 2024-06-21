analyze -sv Multiplier_ConstantTime.v

elaborate -top Multiplier_ConstantTime

clock clk
reset rst

# check_spv -create -from multiplier -to {product}
check_spv -create -from multiplier -to {productDone}

prove -all