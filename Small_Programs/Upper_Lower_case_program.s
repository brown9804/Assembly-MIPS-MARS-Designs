#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             May, 2020


# It is for a MIPS architecture

# This program generally tries to receive a phrase and perform different
# procedures to it with regard to UPPER CASE and LOWER CASE. This is
# must be executed through a menu which is described below:
# 1. Read a string
# 2. First letter of each word in upper case and others in lower case
# 3. First letter in capital letter and the others are lowercase
# 4. Change everything to capital letter
# 5. Change everything to lowercase

# Terms:
# The start is made in $a0
# The character limit to read is defined by $ a1
# Last character entered equals line 0x0A
# New string overwrites value and if it lacks space an additional memory is added

# The algorithm has the following structure in which each step returns to the main logically:
# * Default data
# * Definition of the main where descriptions and user information is called but is infinitely circled
# * Intermediate method
# * Options method

# We start data zone
.data
  generaltitle: .asciiz " \n\n                  oooooooo               Upper / Lower case program                  oooooooo               \n\n "
  menu: .asciiz "\n\n Menu \n\n 1. Read a sentence \n\n 2. First symbol of EACH WORD in UPPERCASE the others in lowercase \n\n 3. First symbol in upper case and all others in lower case \n\n 4. Change ALL to CAPITALS \n\n 5. Change EVERY single char to LOWERCASE \n\n ...... If you do not entry an input you have this as automatic input: Automatic input Tester code  \n\n Know enter the number corresponding to what you want to do: \n\n "
  #Cleaning sceen
  clear:  .asciiz  "\n\n Making space on the screen, lets begin \n\n                  \n\n               \n\n                  \n\n              \n\n                 \n\n               \n\n                   \n\n              \n\n "
  # begining
  continue: .asciiz "\n\n                        Press enter to continue   \n\n  "
  # Confirming the phrase that was received
  confirminput: .asciiz "\n\n                        You have chosen:                                   \n\n "
  # If no row is entered, modify this
  automaticinput: .asciiz "Automatic input Tester code"
  space_prints: .asciiz"\n\n      \n\n"
  # Command for the option to enter the phrase
  # P.D the term characters in programming refers synonymously to phrase
  input: .asciiz "\n\n       Enter the phrase you want to be read:  \n\n"
# Now we must indicate where the memory area dedicated to the instructions begins
# According to the researched theory .text starts by default at 0x00400000 where its first
# instruction is that of the main tag, at address 0x00400020 the simulator is indicated
# start of instructions to execute
.text
  main:
  # register needed foward, we know mips has from $t0-$t7 for temporaries
    li $t0, 0
    li $t1, 0
    li $t2, 0
  # jal works to jump but before doing so save $ra to PC + 4 in the registry
  # In this following commands the $ra is going to be save before jump
    jal welcome_descrip
    jal callingmenu
    jal printings
    jal main

  #                    Welcome and description
  welcome_descrip:
    # The address of the variable description is loaded in register $a0
    la $a0, generaltitle
    # Print the loaded program instruction in console
    li $v0, 4
    # System call allows input / output from outside
  	syscall
    # jr allows to jumps to the address stored in the registry
  	jr $ra

  #                         Menu
  callingmenu:
    # The address of the variable description is loaded in register $a0
    la $a0, menu
    # Print the loaded program instruction in console
    li $v0, 4
    # Allows input / output from outside
    syscall
    # Takes the option submitted for user as an character
    li $v0, 12
    # Allows input / output from outside
    # $v0 allows the of the readed string
    syscall
    #Clean $t3
    and $t3, $t3, $zero
    add $t3, $zero, $v0
    # For option 1
    # If the option is one in ascii is 49
    beq $t3, 49, readinput
    # For option 2
    # If the option is two in ascii is 50
    beq $t3, 50, firstsymwordup
    # For option 3
    # If the option is three in ascii is 51
    beq $t3, 51, upper1lower
    # For option 4
    # If the four option is chosen in ascii is 52
    beq $t3, 52, allcaps
    #For option 5
    # And if its the last five in ascii is 53
    beq $t3, 53, alllower
    # If user dont select any option, clear the screen
    la $a0, clear
    # Print the loaded program instruction in console
    li $v0, 4
    syscall
    # jumps
    jr $ra

  #         Allows to PRINT the information input stored
  printings:
    la $a0, space_prints
    li $v0, 4
    syscall
    la $a0, automaticinput
    li $v0, 4
    syscall
    la $a0, continue
    li $v0, 4
    syscall
    # This folliwing instruction read character so its waiting for an enter
    li $v0, 12
    syscall
    # Goes to .data clear
    la $a0, clear
    li $v0, 4
    syscall
    # Continue with de infinite bucle
    jal main

  #                 METHOD USED # 1 for LOWER
  # Considering that we have several options that require using lowercase letters, the idea
  # is to pass the entire string without print the value and jump to $ra
  allwordslower:
    #  System for address of automatic input
    la $s0, automaticinput
    # Means $s1 = $s0 + $t2
    add $s1, $s0, $t2
    #The lb command sign extends the byte into a thirty-two bit value.
    # As according to the search made, an example from the most
    # significant bit (msb) is copied into the upper twenty four bits
    lb $s2, 0($s1)
    # Checks if $s2  is equal to zero. In that case goes to return
    # written below
    beq $s2, 0, return
    # Means branch if less than makes the function of a slt with bne
    blt $s2, 'A', doinglower
    # Meaning branch if greater than
    bgt $s2, 'Z', doinglower
    # With the following command $s2 = $s2 + 32
    addi $s2, $s2, 32
    # Follows the procedure to store byte in little endian - low order
    sb $s2, 0($s1)
    # Reapeat the procedure
    doinglower:
      addi $t2, $t2, 1
      j allwordslower
    return:
      jr $ra

  #         OPTION 1:   Read the string
  readinput:
    # The character limit to read is established, where 0x7fffffff is a fairly large number
    li $a1, 0x7fffffff
    # The address of the string is obtained
    la $a0, input
    # Print a string what is a character string
    li $v0,4
    #system call allow to input/output with outside
    syscall
    # In order to read the string
    li $v0, 8
    # The address of the string is loaded
    la $a0, automaticinput
    # Output 
    syscall
    la $a0, confirminput
    li $v0, 4
    syscall
    jr $ra

  #         OPTION 2:   First symbol of EACH WORD in UP the others in lowercase
  firstsymwordup:
    #Allows to make every single symbol in lower case
    jal allwordslower
    # It is initialized to zero in order to avoid inconveniences
    li $t2, 0
    # Look for capitals letters and makes some changes
    LFEW:
      # Load the adress of the automaticinput wich is the tester phrase
      la $s0, automaticinput
      # Allows to move on: $s1 = $s0 + $t2
      add $s1, $s0, $t2
      # Load the present char
      lb $s2, 0($s1)
      # If it is the string symbol it goes to printings and prints
      #the results, after this it returns to the main
      beq $s2, 0, printings
      # Now, if it were the case where the first capital letter
      # belonging to each word was not found
      beq $s2, ' ', thereisnocap
      # Takes $t1 as high if cap founds
      beq $t1, 1, lowerchanger
      # blt means branch if less than
      blt $s2, 'a', caseFEW
      # And  bgt branch if greater than
      bgt $s2, 'z', caseFEW
      # If the first cap is not found and if the symbol is between a-z, it makes it cap
      sub $s2, $s2, 32
      # When the first its found
      li $t1, 1
      jal caseFEW
      # For when it no cap
      thereisnocap:
        # Clean $t1 as reboot if no first cap
        li $t1, 0
        jal caseFEW
      #For other lower count
      lowerchanger:
        blt $s2, 'A', caseFEW
        bgt $s2, 'Z', caseFEW
        addi $s2, $s2, 32
      # And for every word
      caseFEW:
        # sb is for follows the procedure to store
        #byte in little endian - low order
        sb $s2, 0($s1)
        # $t2 plus one
        addi $t2, $t2, 1
        jal LFEW

  #         OPTION 3:   First letter in capital letter and the others are lowercase
  upper1lower:
    # Folling the same logic used before
    jal allwordslower
    li $t2, 0
    # Look for first capital letter first lower
    LFCRL:
      la $s0, automaticinput
      add $s1, $s0, $t2
      lb $s2, 0($s1)
      beq $s2, 0, printings
      # When first its founded the rest needs to be lower
      beq $t1, 1, findsFC
      # blt means branch if less than
      blt $s2, 'a', caseU1L
      # And  bgt branch if greater than
      bgt $s2, 'z', caseU1L
      sub $s2, $s2, 32
      # High if first cap founded
      li $t1, 1   # se ha encontrado la primera mayuscula
      jal caseU1L
      findsFC:
        blt $s2, 'A', caseU1L
        bgt $s2, 'Z', caseU1L
        addi $s2, $s2, 32
      caseU1L:
        sb $s2, 0($s1)
        addi $t2, $t2, 1
        jal LFCRL

  #         OPTION 4: Change all to capitals
  allcaps:
    # Using the same ideas used before for making all caps
    la $s0, automaticinput
    add $s1, $s0, $t2
    # Load the actual symbol
    lb $s2, 0($s1)
    beq $s2, 0, printings
    # Branch less/greater than
    blt $s2, 'a', caseAC
    bgt $s2, 'z', caseAC
    # The symbol is in the range described before then sub 32 to upper the char
    sub $s2, $s2, 32
    sb $s2, 0($s1)
    # Goes one by one thats why $t2 = $t2 +1
    caseAC:
        addi $t2, $t2, 1
        jal allcaps

  #         OPTION 5: Change every single char to lowercase
  alllower:
    la $s0, automaticinput
    add $s1, $s0, $t2
    lb $s2, 0($s1)
    # Same principles explained before just with "A" to "Z"
    beq $s2, 0, printings
    blt $s2, 'A', caseAL
    bgt $s2, 'Z', caseAL
    # Plus 32 makes it lower
    addi $s2, $s2, 32
    sb $s2, 0($s1)
    caseAL:
      addi $t2, $t2, 1
      jal alllower
