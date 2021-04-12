#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             June, 2020


# It is for a MIPS architecture

#  function is written which is called "ruleOfThree" which receives...
# The value of a in $a0
# The value of b in $ a1
# The value of c in $a2
# In $v0 it must return the quotient of the division and in
# $v1 the remainder.

# It is assumed that when making the product of b * c the result
# will not exceed 32 bits, also, a, b and c are 32-bit unsigned numbers.


# Some statements and descriptions shown to the user of what will be implemented
.data
	generaltitle: .asciiz " \n\n          oooooooo            Rule of Three            oooooooo               \n\n "
	description: .asciiz "\n\n The algorithm calculate the rule of three being x =(b*c)/a  \n\n"
  choice: .asciiz "+++ Enter 1 to continue \n+++ Enter q for exit... \n\n"
  a_value: .asciiz "\n\n Enter value of a:         "
  b_value: .asciiz "\n\n Enter  value of b:         "
  c_value: .asciiz "\n\n Enter  value of c:         "
  resultQ: .asciiz "   The quotient is        "
  resultR: .asciiz "   The remainder is        "
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
	li $t0, 0 # a
  li $t1, 0 # b
  li $t2, 0 # c
  # Digit the number
  ######## a #############
  li $v0, 4 # Ask for value
  la $a0, a_value
  syscall

  li $v0, 5 # read_integer
  syscall
  move $t0, $v0
  ######## b #############
  li $v0, 4 # Ask for value
  la $a1, b_value
  syscall

  li $v0, 5 # read_integer
  syscall
  move $t1, $v0

  ######## c #############
  li $v0, 4 # Ask for value
  la $a2, c_value
  syscall

  li $v0, 5 # read_integer
  syscall
  move $t2, $v0
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
  add $t6, $zero, $v0 # Option? --->
  beq $t6, 1, ruleOfThree
  beq $t6, 113, exit   # Ascii of q is 113
	jr $ra

# #         Allows to PRINT the information input stored
printings:
	# Prints blank spaces
	la $a0, space_prints
	li $v0, 4
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

	j main

ruleOfThree:
  # b * c
  multu $t1,$t2
  mflo $s0 # LO
  divu $s0,$t0 # (b * c)/a
  mflo $v0 #quotient of the division
  mfhi $v1 # remainder
  # print
  addi $s0, $v0, 0
  addi $s1, $v1, 0
  # print result
	la $a0, resultQ
	li $v0, 4
	syscall

	move $v0, $s0
	li $v0, 1
	syscall

  la $a0, resultR
	li $v0, 4
	syscall

  move $v1, $s1
	li $v0, 1
	syscall

  j printings

exit:
	li $v0, 10 # Terminate execution
	syscall
