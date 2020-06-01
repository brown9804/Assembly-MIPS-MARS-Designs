#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             May, 2020

# It is for a MIPS architecture

#A function is implemented which receives two positive integers entered by the user from which it performs the following logic:

#               C(n, 0) = C(n, n) = 1;                               if n >= 0

#               C(n, k) = C(n-1, k) + C(n-1, k-1);                  if n > k > 0

# It is done through the use of recursion, making use of the stack.
# It is considered that if n <k the user is notified as well as if
# n <0 or k <0. This program was requested to run through an infinite loop.

# Some statements and descriptions shown to the user of what will be implemented
.data
  generaltitle: .asciiz " \n\n                  oooooooo               Recursion Function C(n,k)                 oooooooo               \n\n "
  description: .asciiz "\n\n Conditions: \n\n   C(n, 0) = C(n, n) = 1          if n >= 0  \n\n   C(n, k) = C(n-1, k) + C(n-1, k-1)          if n > k > 0 \n\n"
  continue: .asciiz "\n\n                        Press enter to continue   \n\n  "
  clear: .asciiz "\n\n\n\n\n\n\n\n"
  space_prints: .asciiz"\n\n      \n\n"
  nlessk: .asciiz "\n\n ALERT!!!!!     n number most be greater than k number \n\n"
  nkless0: .asciiz "\n\n ALERT!!!!     Both numbers k and n most be greater than zero  \n\n"
  overagain: .asciiz "\n\n This C(n,k) is finish ....  \n\n"
  ninstru: .asciiz "\n\n Insert the  n value  \n\n"
  kinstru: .asciiz "\n\n Insert the  k value  \n\n"
  C: .asciiz "\n\n  C("
  segmentationmark: .asciiz ", "
  close_result: .asciiz ")   = "


# The space of the instructions to execute is started
.text
  main:
    # Cleaning space of some registers to use
    li $t0, 0 # If n < k $t0 will have 1 as value
    li $t7, 0 # Store n initial value for print
    li $t6, 0 # Store k initial value for print
    li $s0, 0 # For save n value
    li $s1, 0 # For save k value
    # Calls to other functions are implemented within the main
    jal program_title
    jal program_description
    jal read_n
    jal read_k
    jal verify_nk
    jal cnk
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

  #         Allows to PRINT the information input stored
  printings:
    # Prints blank spaces
    la $a0, space_prints
    li $v0, 4
    syscall
    # Prints C(
    la $a0, C
    li $v0, 4
    syscall
    # print n
    move $a0, $t7
    li $v0, 1
    syscall
    # Print ,
    la $a0, segmentationmark
    li $v0, 4
    syscall
    # print k
    move $a0, $t6
    li $v0, 1
    syscall
    # Print ) =
    la $a0, close_result
    li $v0, 4
    syscall
    # Print result r
    move $a0, $s2
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
    # Continue with de infinite bucle
    jr $ra

#               In order to implement the function C(n, k)
  #     Read the n value
  read_n:
    la $a0, ninstru
    # Read the n value as integer
    li $v0, 4
    #system call allow to input/output with outside
    syscall
    # In order to read the integer
    li $v0, 5
    syscall
    # Check if n < 0
    bltz $v0, notify_negative
    # Save the value of n in nvalue
    add $s0, $s0, $v0
    # For print initial n in result
    add $t7, $t7, $s0
    jr $ra
  # Read the k value
  read_k:
    la $a0, kinstru
    # Read the n value as integer
    li $v0, 4
    #system call allow to input/output with outside
    syscall
    # In order to read the integer
    li $v0, 5
    syscall
    # Check if k < 0
    bltz $v0, notify_negative
    # Save the value of n in nvalue
    add $s1, $s1, $v0
    # For print initial k in result
    add $t6, $t6, $s1
    jr $ra
  #Verify if n is greater than k
  verify_nk:
    # We need to know if n > k, if not notify
    # So if $s0 < $s1 ... $t0 == 1
    slt $t0, $s0, $s1
    # Go to notify_nlessk if $t0 == 1
    bne $t0, $zero, notify_nlessk
    jr $ra
# It's for notify the user that the two inputs most positive numbers
  notify_negative:
    # Load the message of n,k most be positive
    la $a0, nkless0
    li $v0, 4
    syscall
    j main
  # It's for notify the user that n most be greater than k
  notify_nlessk:
    # Load the message of n most be greater than k
    la $a0, nlessk
    li $v0, 4
    syscall
    j main
  # Creating the definition of C(n,k)
  cnk: # n expected in $s0 and k in $s1 and r $s2
    # If n == k goes to stop
    sub $t2, $s1, $s0 # t2 == 0
    bne $t2, $0, case2
    li $s2, 1
    jr $ra
  case2: # If k == 0
    bnez $s1, case3
    li $s2, 1
    jr $ra
  case3:
    # Store $ra in stack for recursivity
    addiu $sp, $sp, -4
    sw $ra, 4($sp) # stack $ra
    # Calculate n-1 and storing stack
    sub $t1, $s0, 1
    addiu $sp, $sp, -4
    sw $t1, 4($sp)
    # Calculate k-1 and storing stack
    sub $t2, $s1, 1
    addiu $sp, $sp, -4
    sw $t2, 4($sp)
    # Calling C(n-1,k)
    move $s0, $t1
    # $s1 already stored k
    jal cnk
    # Calling  C(n-1,k-1)
    # Pop k-1 into $s1
    lw $s1, 4($sp)
    addiu $sp, $sp, 4
    # Pop n-1 into $s0
    lw $s0, 4($sp)
    addiu $sp, $sp, 4
    # Push result of C(n-1,k) in stack
    addiu $sp, $sp, -4
    sw $s2, 4($sp)
    jal cnk
    # Pop first result
    lw $s1, 4($sp)
    addiu $sp, $sp, 4
    # Return sum C(n-1,k) + C(n-1, k-1)
    add $s2, $s2, $s1
    # Pop $ra
    lw $ra, 4($sp)
    addiu $sp, $sp, 4
    jr $ra
