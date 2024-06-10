analyze -sv MultiplierTester.v

elaborate -top MultiplierTester

clock clk
reset rst

# keep multiplicand constant to check for information leak of secret (multiplier)
assume {multiplicandOne == multiplicandTwo}

# check if there is a timing attack possible that leaks secret
assert {timingLeakDone -> !timingLeak}

prove -all