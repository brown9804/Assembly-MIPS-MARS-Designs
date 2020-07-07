##--------------------------------Main file------------------------------------
## IE0321 Digital Computer Structures I
## Copyright (C) 2020
## by Belinda Brown Ramírez (belindabrownr04@gmail.com)
## July, 2020
## timna.brown@ucr.ac.cr
##-----------------------------------------------------------------------------

# It is for a MIPS architecture
# Different actions are implemented in a
# unicycle processor


#******************************************************
# INT PART OF SQRT(NUMBER) IN DR.MARS - MIPS
#******************************************************
# The integer part of the square root of a number is
# calculated by counting the number of odd numbers
# (in ascending order) that can be subtracted from
# the base number.
###### example given 34 = 0x22
### 1: left 33   = 0x21
### 3: left 30 = 0x1e
### 5: left 25 = 0x19
### 7: left 18 = 0x12
### 9: left 9 = 0x9
### 11: Can't because result<0
# int part = 5

setup_r:
##### clean up area
li $a0, 34 # num
li $t7, 0 # verifier
addi $t6, $t6, 1 # counter # further -->plus 2 each time
li $t5, 0 # stop condition
li $t4, 1 #compare dr.mips
li $s0, 0 # result of subtract
li $s1, 0 # counter loop

loop:
sub $a0, $a0, $t6 #  r_sub = num -counter
slt $t7, $a0, $t7 # if r_sub <0 -> $t7 = 1
beq $t7, $t4, value # if is true t7 == 1
addi $t6, $t6, 2 #Ex: 3 first
addi $s1, $s1, 1 # counter + 1
beq $t7, $t5, loop #t7 == 0

value:
move $v0, $s1
