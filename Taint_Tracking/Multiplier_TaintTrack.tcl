analyze -sv Multiplier_TaintTrack.v

elaborate -top Multiplier_TaintTrack

clock clk
reset rst -non_resettable_regs 0

# check if there is a taint flow from multiplier to productDone
assume {multiplier_t == 1 && start_t == 0 && multiplicand_t == 0}
assert {productDone -> !productDone_t}

# Set the time limit to 1 hour (3600 seconds)
set_prove_time_limit 3600
set_engine_mode Tri
prove -all
