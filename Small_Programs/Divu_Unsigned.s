
#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             July, 2020


# It is for a MIPS architecture
# The algorithm prompts the user for the divisor and dividend
# (unsigned integers) and prints the result of the division.
# Logic implemented is that the divisor register, ALU, and
# quotient register are all 32 bits wide, with only the
# remainder register left at 64 bits.

.data
  generaltitle: .asciiz " \n\n                  oooooooo              Divisionx ALU                 oooooooo               \n\n "
  description: .asciiz "\n\n The algorithm performs a division using ALU, it consider if 64 bits result \n\n result = num1/num2 \n\n"
  choice: .asciiz "+++ Enter c in order to continue... \n+++ Enter q for exit... \n\n"
  num1: .asciiz "\n\n Enter num1:         "
  num2: .asciiz "\n\n Enter num2:         "
  result0: .asciiz "\n\n The reminder is:        "
  result1: .asciiz "\n\n The quotient is:        "
  continue: .asciiz "\n\n                        Press enter to continue   \n\n  "
  clear: .asciiz "\n\n\n\n\n\n\n\n"
  space_prints: .asciiz"\n\n      \n\n"

.text
main:
  # Calls to other functions are implemented within the main
  jal program_title
  jal program_description
  jal setup_r
  jal iteration
  jal printings
  j main

#             Printing the program title
program_title:
  # Loaded in register $a0 the adress of the generaltitle
  la $a0, generaltitle
  # Print general title in console
  li $v0, 4
  # Output
  syscall
  # And we need to jump to the address stores in the registry
  jr $ra

# Printing the program description
program_description:
  # Loaded in register $a0 the adress of the description
  la $a0, description
  # Print description in console
  li $v0, 4
  # Output
  syscall
  # And we need to jump to the address stores in the registry
  jr $ra

setup_r:
  # Cleaning space of some registers to use
  and $t0, $zero, $t0 # Will save num1
  and $t1, $zero, $t1 # Will save num2
  and $t2, $zero, $t2 # MSB part
  and $t3, $zero, $t3 # LSB part
  li $t4, 0 # For some conditions
  li $t7, 0x80000000 # Mask of MSB
  li $s0, 17 # Counter 32 bits loop
  # # # # # # # # # #           Options          # # # # # # # # # #
  # The address of the variable description is loaded in register $a0
  la $a0, choice
  # Print the loaded program instruction in console
  li $v0, 4
  # Allows input / output from outside
  syscall
  # Takes the option submitted for user as an character
  li $v0, 12
  # Allows input / output from outside
  # $v0 allows the of the readed string
  syscall
  and $t6, $t6, $zero
  add $t6, $t6, $v0 # Option? --->
  beq $t6, 99, read_numbers # Ascii of c is 99
  beq $t6, 113, exit   # Ascii of q is 113
	jr $ra

# #         Allows to PRINT the information input stored
printings:
  # Prints blank spaces
  la $a0, space_prints
  li $v0, 4
  syscall

  li $v0, 4
  la $a0, result0
  syscall

  li $v0, 36  # print unsigned
  move $a0, $t3
  syscall

  li $v0, 4
  la $a0, result1
  syscall

  li $v0, 36  # print unsigned
  move $a0, $t2
  syscall

  la $a0, continue
  li $v0, 4
  syscall

  # This folliwing instruction read character so its waiting for an enter
  li $v0, 12
  syscall

  # Prints several blank lines in order to clear the console
  la $a0, clear
  li $v0, 4
  syscall

  jr $ra

read_numbers:
  li $v0, 4 # Ask for number1
  la $a0, num1
  syscall

  li $v0, 5 # read_integer
  syscall
  move $t3, $v0 # load the dividend into the reminder

  li $v0, 4 # Ask for number2
  la $a0, num2
  syscall

  li $v0, 5  # read_integer
  syscall
  sll $t1, $v0, 16
  jr $ra

iteration:
  #li  $v0, 0xFFFF0000
  #and $v1, $t3, $v0
  #beq $v1, $t1, final_shift

  beq $s0, $zero, final_shift # if counter == 0
  addi $s0, $s0, -1 # Counter -1
  
  subu $t3, $t3, $t1 # Remainder = remainder - divisor
  and $t4, $t3, $t7 # Check if the reminder is negative
  beq $t4, $zero, positive_remainder
  add $t3, $t3, $t1 # Restore original reminder
  sll $t3, $t3, 1
  li  $v0, 0xFFFFFFFE
  and $t3, $t3, $v0  # R0 = 0
  j iteration

positive_remainder:
  sll $t3, $t3, 1
  or $t3, $t3, 1 # R0 = 1
  j iteration
  
final_shift:
  # Put quotient in t2
  move $t2, $t3
  andi $t2, $t2, 0xFFFF
  # Put the reminder in t3
  srl $t3, $t3, 17
  
  jr $ra
  
exit:
  li $v0, 10 # Terminate execution
  syscall
