analyze -sv MultiplierTester.v

elaborate -top MultiplierTester

clock clk
reset rst

# check if there is a timing attack possible that leaks secret
assert {multiplicandOne == multiplicandTwo && timingLeakDone -> !timingLeak}

#Commutative Property
# assert {multiplicandOne == multiplierTwo && multiplicandTwo == multiplierOne && productDoneOne && productDoneTwo -> commutativeProp}

#Associative Property
# assert {productDoneOne && productDoneThree && multiplierTwo == productOne && multiplicandTwo == multiplierThree && multiplierThree == multiplicandOne 
#     && multiplicandThree == multiplierThree && multiplierFour == multiplierOne && multiplicandFour == productThree && productTwo &&
#        productDoneFour -> assocProp}

# Set the time limit to 1 hour (3600 seconds)
set_prove_time_limit 3600
prove -all
