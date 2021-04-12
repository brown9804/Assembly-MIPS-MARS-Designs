
#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             June, 2020


# It is for a MIPS architecture

# A program is performed that converts Celsius to Fahrenheit and from Fahrenheit to Celsius.
# Enter the signed number
# 0 if Celsius to Fahrenheit or 1 if Fahrenheit to Celsius.
# Returns the quotient in $v0 and the remainder in $v1 and no more than 32 bits.

# Some statements and descriptions shown to the user of what will be implemented
.data
	generaltitle: .asciiz " \n\n          oooooooo            Celsius to Fahrenheit and vice versa            oooooooo               \n\n "
	description: .asciiz "\n\n The algorithm converts the entered temperature and passes it to the other scale  \n\n"
  choice: .asciiz "+++ Enter 1 in order to convert to Celsius... Enter 0 in order to convert to Fahrenheit... \n+++ Enter q for exit... \n\n"
  num1: .asciiz "\n\n Enter num1:         "
  r_celsius: .asciiz "   grades of Celsius        "
  r_fah: .asciiz "\n\n grades of Fahrenheit      "
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
	li $t0, 0 # value
  li $t1, 9
  li $t2, 5
  li $t3, 32
  li $t4, 0 #mflo
  li $t7,0
  li $s0, 0
  li $s1, 0
  # Digit the number
  li $v0, 4 # Ask for value
  la $a0, num1
  syscall

  li $v0, 5 # read_integer
  syscall
  move $t0, $v0
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
  beq $t6, 1, grades_celsius
  beq $t6, 0, grades_fah
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

grades_fah:
  # Calculate
  mult $t0, $t9 # C * 9
	mflo $t4		# LO
	div $t4, $t2 #  C * 9/ 5
	mflo $v0		# quotient
	mfhi $v1		# remainder
	add $v0,$v0, $t3 #quotient C * 9/ 5 +32
  addi $s0, $v0, 0
  addi $s1, $v1, 0
  # print result
	move $a0, $s0
	li $v0, 1
	syscall

  move $a0, $s1
	li $v0, 1
	syscall

	la $a0, r_fah
	li $v0, 4
	syscall
  j printings

grades_celsius:
  sub $t7, $t0, $t3 # t7 = F - 32
	mult $t7, $t2 # ( F - 32)*5
	mflo $t4		#  LO
	div $t4, $t1	# ( F - 32)*5/9
	mflo $v0		# quotient
	mfhi $v1		# remainder
  addi $s0, $v0, 0
  addi $s1, $v1, 0
  # print result
	move $a0, $s0
	li $v0, 1
	syscall

  move $a0, $s1
	li $v0, 1
	syscall

	la $a0, r_celsius
	li $v0, 4
	syscall
  j printings


exit:
	li $v0, 10 # Terminate execution
	syscall
