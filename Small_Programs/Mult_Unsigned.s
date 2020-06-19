#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             June, 2020


# It is for a MIPS architecture

# Console requests the multiplier and the multiplicand
# (unsigned integers) and prints the result of the multiplication.

# The algorithm is created using arithmetic logic unit (ALU) that uses
# shift and add is a digital circuit that calculates arithmetic operations.

# Some statements and descriptions shown to the user of what will be implemented
.data
	generaltitle: .asciiz " \n\n                  oooooooo              Multiplication ALU                 oooooooo               \n\n "
	description: .asciiz "\n\n The algorithm performs a multiplication using ALU, it consider if 64 bits result \n\n result = num1*num2 \n\n"
  choice: .asciiz "+++ Enter c in order to continue... \n+++ Enter q for exit... \n\n"
  num1: .asciiz "\n\n Enter num1:         "
  num2: .asciiz "\n\n Enter num2:         "
  result0: .asciiz "\n\n The result is:        "
  result1: .asciiz "\n\n The upper part of the multiplication is:           "
	continue: .asciiz "\n\n                        Press enter to continue   \n\n  "
	clear: .asciiz "\n\n\n\n\n\n\n\n"
	space_prints: .asciiz"\n\n      \n\n"

.text
main:
  # Calls to other functions are implemented within the main
  jal program_title
  jal program_description
  jal setup_r
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

#             Printing the program description
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
  li $t7, 1 # Mask for extract one bit
	li $s0, 32 # Counter 32 bits loop
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

  li $v0, 1  # if using mars replace 1 by 36 to print as an unsigned
  add $a0, $t3, $zero
  syscall

  li $v0, 4
  la $a0, result1
  syscall

  li $v0, 1 # if using mars replace 1 by 36 to print as an unsigned
  add $a0, $t2, $zero
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

	jal main

read_numbers:
  li $v0, 4 # Ask for number1
  la $a0, num1
  syscall

  li $v0, 5 # read_integer
  syscall
  move $t0, $v0

  li $v0, 4 # Ask for number2
  la $a0, num2
  syscall

  li $v0, 5  # read_integer
  syscall
  move $t1, $v0

mulitplication:
  and $s2, $t1, $t7
  beq $s2, 0, iteration
  addu $t2, $t2, $t0

iteration:
  sll $t7, $t7, 1 # update mask
  andi $s4, $t2,1  # Save the LSB of result0
  srl $t2,$t2,1    # t2 greater than 1
  srl $t3,$t3,1    # t3 greater than 1
  sll $s4,$s4, 31
  or  $t3, $t3, $s4  # LSB of result0 in MSB of $t3
  addi $s0, $s0, -1 # Counter -1
  beq $s0, $zero, printings # When counter
  j mulitplication

exit:
	li $v0, 10 # Terminate execution
	syscall
