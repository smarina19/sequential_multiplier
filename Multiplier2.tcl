analyze -sv Multiplier.v

elaborate -top Multiplier

clock clk
reset rst

# check_spv -create -from multiplier -to {product}
check_spv -create -from multiplier -to {productDone}

# Set the time limit to 1 hour (3600 seconds)
set_prove_time_limit 3600
set_engine_mode Tri
prove -all