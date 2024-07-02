analyze -sv Multiplier_StateBranch.v

elaborate -top Multiplier_StateBranch

clock clk
reset rst

# check_spv -create -from multiplier -to {product}
check_spv -create -from multiplier -to {productDone}

prove -all
