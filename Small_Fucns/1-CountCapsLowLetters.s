#                Digital computer structures I
#                    Belinda Brown Ramirez
#                        May, 2020
#                    timna.brown@ucr.ac.cr

# It is for a MIPS architecture

# The following function:
# 1. Receive the address of a string (character array) of type ASCIIZ in $a0
# 2. Count the number of characters equal to a capital letter.
# 3. Count the number of characters equal to a lowercase letter.
# 4. Returns in $v0 the number of capital letters in the string and in $v1 the number of lowercase letters.

# Capital letters correspond to the interval ['A' - 'Z'] = [0x41 - 0x5A]
# Lowercase letters correspond to the interval ['a' - 'z'] = [0x61 - 0x7A]
#         $t0               # Letter word counter
#         $v0               # Sum capital letters
#         $v1               # Sum lowercase letters
#         $t1               # A[i] register
#         $t2               # i    value
#         $t3               # Count for capital letters
#         $t4               # Counter lowercase letters



# Cleaning spaces for counters
clean:
  li $t0, 0 # Letter word counter
  li $v0, 0 # Count for capital letters
  li $v1, 0 # Counter lowercase letters
  li $t1, 0 # A[i] register
  li $t2, 0 # i    value

begin: # Begin
  # $t2  will hav array[i]  who is the position into the array
  #  A[i] = A + ix4
  sll $t1, $t0, 2 # ix4
  add $t1, $t1, $a0 # ix4 + A = A[i]
  # Load word for the steps above
  lb $t2, 0($t1) # Load word i from A[i] nomenclature but its a letter so ix4
  beq $t2, $0, end # if NULL

# Fuction for Capital letter
capletter:
  #           Identification
  # Means branch if less than makes the function of a slt with bne
  blt $t2, 'A', capcounter
  # Meaning branch if greater than
  bgt $t2, 'Z', capcounter
  #         Counting the letters
  capcounter:
    addi $t3, $0, 1 #  Count for capital letters
    forcap:
      # $a2 = 0 n >= Count for capital letters; $a2 = 1 n < i
      slt $a2, $t2, $t3
      bne $a2, $0, endforcap
      addi $v0, $v0, $t3
      addi $t3, $t3, 1
      j forcap
    endforcap:
      # jr allows to jumps to the address stored in the registry
      jr $ra
# Fuction for Lowercase letter
lowerletter:
  #               Identification
  # blt means branch if less than
  blt $t2, 'a', lowercounter
  # And  bgt branch if greater than
  bgt $t2, 'z', lowercounter
  lowercounter:
    addi $t4, $0, 1 #  Count for lowercase letters
    forlow:
      # $a2 = 0 n >= Count for capital letters; $a2 = 1 n < i
      slt $a2, $t2, $t4
      bne $a2, $0, endforlow
      addi $v1, $v1, $t4
      addi $t4, $t4, 1
      j forlow
    endforlow:
      # jr allows to jumps to the address stored in the registry
      jr $ra
end:
