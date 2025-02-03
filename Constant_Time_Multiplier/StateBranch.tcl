analyze -sv Multiplier_StateBranch.v

elaborate -top Multiplier_StateBranch

clock clk
reset rst

check_spv -create -from multiplier -to {productDone}

set_prove_time_limit 3600
prove -all