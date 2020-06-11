#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             May, 2020


# It is for a MIPS architecture

# A function is performed that calculates the arithmetic
# mean (average) of an array of words, this array contains
# only positive numbers, a negative number indicates that
# the end of the array has been reached.

# The following is considered:
# 1. The address of the array is entered through register $a0.
# 2. Return in $v0 the integer part of the average and in $v1
# the remainder of the average.
# 3. Use only instructions that do not generate exceptions.
# 4. Check that the result of the sums is correct.
# 5. Notification if you have the inability to calculate the
# average because the result of the sums does not fit,
# in which case -1 in $v0 and $v1.
# 6. Use of three arrays by default, one of them with carry
# error of these at least one must generate a carry error.
# 7. Printing of arrays, results or notification.



# Some statements and descriptions shown to the user of what will be implemented
.data
	generaltitle: .asciiz " \n\n                  oooooooo               Arithmetic                 oooooooo               \n\n "
	description: .asciiz "\n\n Average using 3 arrays  \n\n1. A = [1,4,2,-1] \n\n2. B = [2,2,1,3,-1] \n\n3. C = [2,4,6,1700000000000,28,-1] \n\n4. Exit\n\n"
	choice: .asciiz "\n\n Enter the number of option that you wanna go:     "
	continue: .asciiz "\n\n                        Press enter to continue   \n\n  "
	clear: .asciiz "\n\n\n\n\n\n\n\n"
	space_prints: .asciiz"\n\n      \n\n"
	cant_av: .asciiz "\n\n ALERT!!!!!     Carry of data (not fit). Unable to calculate average \n\n"
	sum_comment: .asciiz "\n\n The sum of all elements is:     "
	quotient: .asciiz "\n\n Quotient =  "
	remainder:  .asciiz "\n\n Remainder =  "
	# -1 is flag for end array
	A: .word 1,4,2,-1 # sum = 7
	B: .word 2,2,1,3,-1 # sum = 8
	C: .word 2,4,6,1700000000000,28,-1 # sum = 1700000000040  ----> carrying
	sizeA: .word 3
	sizeB: .word 4
	sizeC: .word 5
	result: .asciiz "\n\n This average is ....  \n\n"

# The space of the instructions to execute is started
.text
main:
# Calls to other functions are implemented within the main
jal program_title
jal program_description
jal setup_r
jal sum #implicit choice
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
	and $t0, $zero, $t0
	and $t1, $zero, $t1
	and $t2, $zero, $t2
	and $t3, $zero, $t3
	and $t4, $zero, $t4
	li $t6, -1 # Condition end array
	and $t8, $zero, $t8 # Ask if carry
	li $s0, 0 # Save printable quotient A
	li $s1, 0 # Save printable remainder A
	jr $ra

# #         Allows to PRINT the information input stored
printings:
	# Prints blank spaces
	la $a0, space_prints
	li $v0, 4
	syscall

	# Print sum comment
	la $a0, sum_comment
	li $v0, 4
	syscall

	# Print result sum
	move $a0, $t3
	li $v0, 1
	syscall

	# Result is ...
	la $a0, result
	li $v0, 4
	syscall

	# Quotient average is ...
	la $a0, quotient
	li $v0, 4
	syscall

	# Print avarage quotient
	move $a0, $s0
	li $v0, 1
	syscall

	# Remainder average is ...
	la $a0, remainder
	li $v0, 4
	syscall

	# Print avarage remainder
	move $a0, $s1
	li $v0, 1
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

#               Sum all elements
sum:
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
	and $t7, $t7, $zero
	add $t7, $t7, $v0 # Option? --->
	# For option 1
	# If the option is one in ascii is 49
	beq $t7, 49, caseA
	# For option 2
	# If the option is two in ascii is 50
	beq $t7, 50, caseB
	# For option 3
	# # If the option is three in ascii is 51
	beq $t7, 51, caseC
	# # For option 4
	# If the four option is chosen in ascii is 52
	beq $t7, 52, exit
	# We have to sum all elements of every array to further divided by n
	# n is the number of elements in every single array

caseA:
	la $t0, A
	lw $t2, sizeA
	loop1:
		lw $t4, 0($t0) # t4 = A[i]
		addu $t3, $t3, $t4 # sum = sum + A[i]
		addu $t1, $t1, 1 # i = i +1
		addu $t0, $t0, 4 # Update A address
		# Verify if not carry
		xor $t8, $t3, $t4  # Checks sum and A[i] differ on sing
		slt $t8, $t8, $zero  # $t8 = 1 if sing are different
		bne $t8, $zero, carry # Both number has sing different
		blt $t1, $t2, loop1
		j no_carry

caseB:
	la $t0, B
	lw $t2, sizeB
	loop2:
		lw $t4, 0($t0) # t4 = B[i]
		addu $t3, $t3, $t4 # sum = sum + B[i]
		addu $t1, $t1, 1 # i = i +1
		addu $t0, $t0, 4 # Update B address
		# Verify if not carry
		xor $t8, $t3, $t4  # Checks sum and B[i] differ on sing
		slt $t8, $t8, $zero  # $t8 = 1 if sing are different
		bne $t8, $zero, carry # Both number has sing different
		blt $t1, $t2, loop2
		j no_carry

caseC:
	la $t0, C
	lw $t2, sizeC
	loop3:
		lw $t4, 0($t0) # t4 = C[i]
		addu $t3, $t3, $t4 # sum = sum + C[i]
		addu $t1, $t1, 1 # i = i +1
		addu $t0, $t0, 4 # Update C address
		# Verify if not carry
		xor $t8, $t3, $t4  # Checks if sum and C[i] differ on sing
		slt $t8, $t8, $zero  # $t8 = 1 if sing are different
		bne $t8, $zero, carry # Both number has sing different
		blt $t1, $t2, loop3
		j no_carry

averageX:
	divu $t3, $t2  # Divides sum by n
	# Example 10/3 = 3.333
	# Quotient = 3
	# Remainder = 3.33
	li $v0, 0
	li $v1, 0
	mfhi $v1    # Move remainder
	addu $s1, $zero, $v1
	mflo $v0     # Move quotient
	addu $s0, $zero, $v0
	j printings
# 							Ask for carry condition
no_carry:
	jal averageX

carry:
	# Loaded in register $a0 the adress of the carry alert
	la $a0, cant_av
	# Print description in console
	li $v0, 4
	# Output
	syscall
	# Condition load -1
	li $v0,-1
	li $v1,-1
	# And we need to jump to the address stores in the registry
	jal main

exit:
	li $v0, 10 # Terminate execution
	syscall
