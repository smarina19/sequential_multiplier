analyze -sv Multiplier.v

elaborate -top Multiplier

clock clk
reset rst

# Communitivity Check
check_spv -create -from multiplier -to {product productDone}

prove -all