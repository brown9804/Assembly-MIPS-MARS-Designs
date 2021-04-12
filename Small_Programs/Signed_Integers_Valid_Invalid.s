#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             June, 2020


# Perform a function in assembly language, for a MIPS architecture


# This function receives two signed integers through the registers $a0 and $a1.
# Add both numbers and check if the result is valid:
# 1. The result is valid, it returns in $v0 and in $v1 a zero
# 2. The result is invalid, it must be returned in $v0 what the sum and a -1 in $v1.

# Instructions that do not generate exceptions are used.

# Cleaning spaces
clean:
  li $t0, 0 # Will be used to save A value
  li $t1, 0 # Will be used to  save B value
  li $t3, 0 # Will be used to save sum value
  li $t4, 0 # Will be used to ckeck sing
  li $v0, 0 # Save final result
  li $v1, 0 # Save valid condiction

begin:
  lw $t0, 0($a0) # Load  A number
  lw $t1, 0($a1) # Load B number
  addu $t3, $t0, $t1 # A + B

  # Verify if not overflow
  xor $t4, $t0, $t1  # Checks if A and B differ on sing
  slt $t4, $t4, $zero  # $t4 = 1 if sing are different
  bne $t4, $zero, no_overflow # Both number has sing different

  # Verify if overflow
  xor $t4, $t0, $t1  # if same sing $t4 = 0
  slt $t4, $t4, $zero # $t4 = 1 if sum sign different
  bne $t4, $zero, overflow

no_overflow:
  addu $v0, $v0, $t3
  addu $v1, $zero, 0 #if no overflow valid condition = 0
  j exit

overflow:
  addu $v1, $v1, $t3
  addu $v1, $zero, -1 # valid condition = -1
  j exit

exit:
