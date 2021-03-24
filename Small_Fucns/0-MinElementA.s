#                Digital computer structures I
#                    Belinda Brown Ramirez
#                        May, 2020
#                    timna.brown@ucr.ac.cr


# Perform a function in assembly language, for a MIPS architecture

# It receives in register $a0 the address of an array of words (32-bit integers),
# this array ends in null (0x00000000). The function must return in the register
# $v0 the minor element of the array. The numbers stored in the array are
# considered to be signed numbers.


# Cleaning spaces
clean:
  li $t0, 0 # Element counter
  li $t7, 0 # Value compare
  li $v0, 0 # Where store the minor element of the array
begin:
  # $t1  will hav array[i]  who is the position into the array
  #  A[i] = A + ix4
  sll $t1, $t0, 2 # ix4
  add $t1, $t1, $a0 # ix4 + A = A[i]
  lw $t2, 0($t1) # Load word i from A[i] nomenclature but its a word so ix4
minor_element:
  beq $t2, $0, end # if NULL
  slt $t7, $t2, $v0 # compare if i < minor element
  bne $t7, minor_element # if $t7 is not zero continue the loop
  sw $t7, 0($v0) # Save the new minor value
  j minor_element
end:
