#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             June, 2020


# Perform a function in assembly language, for a MIPS architecture

# This function receives the address of an array of words from $ a0, it has 32-bit
# numbers ending in NULL, which means that the last element is an array of
# 0x00000000. For example: [4, 19, 0].

# In the $a1 and $a2 register is the address of two other word arrangements.
# Because of this the program loops through the array of numbers contained in
# the address $a0. And compare the data read with two conditions:

# 1. If the die is less than zero it is saved in the array found in $a1.
# 2. If it is greater than zero it is saved in $a2.

# When all elements are verified, the NULL is stored.


# Cleaning spaces
clean:
  li $t0, 0 # General counter for i on A[i]
  li $t2, 0 # Space for direction A[i]
  li $t3, 0 # Value i
  li $t4, 0 # For temporal direction of $a1
  li $t5, 0 # For temporal direction of $a1
  # Because we need to subtract or add one
  li $v0, 0 # Save number < 0
  li $v1,0 # Save number > 0
begin: # Begin
  # $t2  will have array[i]  who is the position into the array
  #  A[i] = A + ix4
  sll $t2, $t0, 2 # ix4
  add $t2, $t2, $a0 # ix4 + A = A[i]
  lw $t3, 0($t2) # Load word i from A[i] nomenclature but its a word so ix4
condi_number:
  # If A[i] > 0
  bgtz $t3, save_a1
  bltz $t3, save_a2
  beq $t3, $0, end # if NULL
save_a1:
  add $v0, $v0, $t3 # Save value
  add $t2, $t2, $a0 # Update direction on $a0
  add $t4, $t4, $a1 # Update  direction on $a1
  j condi_number
save_a2:
  add $v1, $v1, $t3 # save value
  add $t2, $t2, $a0 # Update direction on $a0
  add $t4, $t4, $a1 # Update  direction on $a1
  j condi_number
end:
    # Save NULL in $v0
    add $v0, $v0, $0
    # Save NULL in $v1
    add $v1, $v1, $0
