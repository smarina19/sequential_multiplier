analyze -sv Multiplier_ConstantTimeTester.v

elaborate -top Multiplier_ConstantTimeTester

clock clk
reset rst

# check if there is a timing attack possible that leaks secret
assert {multiplicandOne == multiplicandTwo && timingLeakDone -> !timingLeak}

# Set the time limit to 1 hour (3600 seconds)
set_prove_time_limit 3600
prove -all
