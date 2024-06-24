analyze -sv Multiplier_Constant2CopyTester.v

elaborate -top Multiplier_ConstantTimeTester

clock clk
reset rst

# check if there is a timing attack possible that leaks secret
assert {multiplicandOne == multiplicandTwo && timingLeakDone -> !timingLeak}
