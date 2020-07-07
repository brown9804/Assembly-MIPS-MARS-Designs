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
#  CLOCK PERIOD
#******************************************************
# The added times are presented in the diagram in the
# results folder under the name of clk_period.png
# The calculation of the clock period for the unicycle
# processor with the latency times, is given by:
# add + alu + data_memory = total_period
# 500 ns + 200 ns + 600 ns = 1300 ns

#******************************************************
#  CLOCK PERIOD
# PLUS PIPELINE OF FIVE STAGES
#******************************************************
# The clock period if a 5-stage pipeline is implemented
# with the defined times is given by the following line
# of thought.At this stage, what is considered is the
# module that takes the longest to execute (latency time)
# plus a pipeline time. Since the idea is to stabilize
# considering the execution time of the modules.

# The module with the longest latency time is the data_memory,
# so 600 ns plus the pipeline time are considered (which
# is 6 ns), resulting in a clock period of 606 ns.

# It is important to consider that the latency times are
# found in the docs folder in the image of latencies.png
# and in the image of the datapath.png they are entered
# on each module.

#******************************************************
#  CLOCK PERIOD
# SINGLE INSTRUCTION AND PIPELINE
#******************************************************
# Below is the necessary to calculate the duration in the
# execution of a single instruction if a 5-stage pipeline
# is implemented. Considering that all the stages have to
# last the same, the slowest stage is taken in this case
# is the data_memory stage plus the pipeline and if it
# multiplies by 5 since there are 5 stages. Allowing all
# stages to last as long as the slowest stage lasts. So:

# 606 ns * 5 = 3030 ns

#******************************************************
# POWER CONSUMPTION
# OF THE SW $RT, INM($RS)
#******************************************************
# About the power consumption of the sw $ Rt, Inm ($ Rs)
# instruction in the unicycle processor.
# The path is followed until completing the sw instruction
# which happens in the data_memory where it passes through
# the path which is seen in the image energy_consumption.png
# plus the consideration of the energy of the read and write
# pipeline.

# Instruction memory + pipeline write + pipeline read +
# register write + register read + alu + data_memory write

# 55 + 20 + 10 + 12 + 10 + 2 + 120 = 229 pJ

#******************************************************
# INT PART OF SQRT(NUMBER) IN MARS - MIPS
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

.data
num: .asciiz " \n\n Enter the number to which you want to calculate the integer part of the square root: "
result: .asciiz " \n\n The result is:      "

.text
read_number:
li $v0, 4 # Ask for number
la $a0, num
syscall

li $v0, 5 # read_integer
syscall

setup_r:
##### clean up area
li $a0, 0 # num
li $t7, 0 # verifier
addi $t6, $t6, 1 # counter # further -->plus 2 each time
li $t5, 0 # stop condition
li $s0, 0 # result of subtract
li $s1, 0 # counter loop

move $t0, $v0 # load the number in $t0

loop:
sub $t0, $t0, $t6 #  r_sub = num -counter
slt $t7, $t0, $t7 # if r_sub <0 -> $t7 = 1
bne $t7, $t5, value # if is true
addi $t6, $t6, 2 #Ex: 3 first
addi $s1, $s1, 1 # counter + 1
j loop

value:
#### Here will be printing
li $v0, 4
la $a0, result
syscall

move $a0, $s1
li $v0,1   # print
syscall

li $v0, 10 # Terminate execution
syscall

#******************************************************
# MACHINE LANGUAGE
#******************************************************

# The machine language encoding of the program must
# obtain the value of 32 bits. For each instruction,
# all the values of the control signals of the unicycle
# processor are determined, as well as the ALU signals.
# It is determined if there are data and control risks
# in the program carried out and when to forward or stop
# the pipeline.


## HEXADECIMAL TABLE --> MACHINE LANGUAGE OF main_Dr_Mips.s

# Instruction	                     Type	                    opcode	           rs	         rt	       rd/Immediate      shamt     	func

# setup_r:
# li $a0, 34                    PSEUDOINSTRUCTION SET	     	 	 0x00
# li $t7, 0                     PSEUDOINSTRUCTION SET	     	 	 0x00
# addi $t6, $t6, 1              I            	                 0x08        0xAA        0xAA          0x01             0x00    		 NA
# li $t5, 0                    PSEUDOINSTRUCTION SET	     	 	 0x00
# li $t4, 1                    PSEUDOINSTRUCTION SET	     	 	 0x00
# li $s0, 0                    PSEUDOINSTRUCTION SET	     	 	 0x00
# li $s1, 0                    PSEUDOINSTRUCTION SET	     	 	 0x00

# loop:
# sub $a0, $a0, $t6             R                           	  0x00       0xAA        0x08          0x01            0x00   		 0x22
# slt $t7, $a0, $t7             R                               0x00       0x04        0x17          0x12            0x00        0xa2
# beq $t7, $t4, value           I         		                  0x04       0x08        0x09          value           0x00    		   NA
# addi $t6, $t6, 2              I            	                  0x08       0xAA        0xAA          0x02            0x00    		   NA
# addi $s1, $s1, 1              I            	                  0x08       0xAA        0xAA          0x01            0x00    		   NA
# beq $t7, $t5, loop            I         		                  0x04       0x08        0x09          loop            0x00    		   NA

# value:
# move $v0, $s1                PSEUDOINSTRUCTION SET	     	 	 0x00
