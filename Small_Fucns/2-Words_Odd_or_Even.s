#                Digital computer structures I
#                    Belinda Brown Ramirez
#                        May, 2020
#                    timna.brown@ucr.ac.cr


# Perform a function in assembly language, for a MIPS architecture


# in $a0 the address of a set of words ending in
# NULL, the function must return in $v0 the number of words
# even and in $v1 the number of odd words, specifically,
# to the even words you must add 1 and the odd ones subtract 1,
# the word NULL must not be modified.

# This script does not show the results on the screen

# If you are doing some analysis and you need to manipulate
# the result of it, you can use register 2 and 3 under the
# name of $v0 and $v1 respectively.
# To handle temporary data you can register $t0 - $t7


# Cleaning spaces for counters
clean:
  li $t0, 0 # Words counter
  # Because we need to subtract or add one
  li $v0, 0 # Count for even words here we are to add 1
  li $v1,0 # Counter odd words sub 1

begin: # Begin
  # $t2  will hav array[i]  who is the position into the array
  #  A[i] = A + ix4
  sll $t2, $t0, 2 # ix4
  add $t2, $t2, $a0 # ix4 + A = A[i]
  # Load word for the steps above
  lw $t3, 0($t2) # Load word i from A[i] nomenclature but its a word so ix4
  beq $t3, $0, end # if NULL
mask1value:
  # Mask of the value one, simplier terms [1]
  addi $t1, $0, 1  # $t1 = 0 + 1
  # Using the mak for available the word to compare with 1 vs 0
  and $t4, $t1, $t3 # $t4 <NEW REGISTER> = $t1  <MASK> & $t3 <i>
  beq $t4, $0, even # if $t1  <MASK> & $t3 <i> == 0 jump to even (par) label
  # If not, means $t1  <MASK> & $t3 <i> == 1 jump to odd (impar)
  # Quick terms: odd(impar) = 1 and even (par) = 0
odd:
  addi $v1, $v1, 1 # Counter for odd words plus one
  sub $t3, $t3, 1 # Odd word - 1
  sw $t3, 0($t2) # Save word: $t2 ... A[i] and $t3 ... i
  addi $t0, $t0, 1 # $t0 ... words counter so words counter plus one
  j begin # Repeat until NULL in that case goes to end
even:
  addi $v0, $v0, 1 # Counter for odd words plus one
  addi $t3, $t3, 1 # Even word + 1
  sw $t3, 0($t2) # Save word: $t2 ... A[i] and $t3 ... i
  addi $t0, $t0, 1 # $t0 ... words counter so words counter plus one
  j begin # Repeat until NULL in that case goes to end
end:
