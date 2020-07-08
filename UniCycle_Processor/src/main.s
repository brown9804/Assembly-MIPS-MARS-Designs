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

#Example of code using...

# setup_r:
# ##### clean up area
# addi $a0, $a0, 34 # num
# addi $t7,$t7, 0 # verifier
# addi $t6, $t6, 1 # counter # further -->plus 2 each time
# addi $t5, $t5, 0 # stop condition
# addi $t4,$t4, 1 #compare dr.mips
# addi $s0,$s0, 0 # result of subtract
# addi $s1,$s1, 0 # counter loop
#
# loop:
# sub $a0, $a0, $t6 #  r_sub = num -counter
# slt $t7, $a0, $t7 # if r_sub <0 -> $t7 = 1
# beq $t7, $t4, value # if is true t7 == 1
# addi $t6, $t6, 2 #Ex: 3 first
# addi $s1, $s1, 1 # counter + 1
# beq $t7, $t5, loop #t7 == 0
#
# value:
# add $v0, $s1, $v0




## HEXADECIMAL  --> MACHINE LANGUAGE OF main_Dr_Mips.s

# Instruction	                     Type	                    opcode

# setup_r:
# addi $a0, $a0, 34             I            	                 0x08
# addi $t7, $t7, 0              I            	                 0x08
# addi $t6, $t6, 1              I            	                 0x08
# addi $t5,$t5, 0               I            	                 0x08
# addi $t4, 1                   I            	                 0x08
# addi $s0, s0, 0               I            	                 0x08
# addi $s1,s1,  0               I            	                 0x08
# sub $a0, $a0, $t6             R                           	 0x00
# slt $t7, $a0, $t7             R                              0x00
# beq $t7, $t4, value           I         		                 0x04
# addi $t6, $t6, 2              I            	                 0x08
# addi $s1, $s1, 1              I            	                 0x08
# beq $t7, $t5, loop            I         		                 0x04

# value:
# add $v0, $v0, $s1             R            	                  0x00



#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################

#************************************************************************************************
# INSTRUCTION                           BINARY                          HEXADECIMAL
#************************************************************************************************
##### setup_r:
# addi $a0, $a0, 34          00100000100001000000000000110100          0x20840034
# addi $t7, $t7, 0           00100001111011110000000000000000          0x21EF0000
# addi $t6, $t6, 1           00100001110011100000000000000001          0x21CE0001
# addi $t5,$t5, 0            00100001101011010000000000000000          0x21AD0000
# addi $t4, $t4, 1           00100001100011000000000000000001          0x218C0001
# addi $s0, $s0, 0           00100010000100000000000000000000          0x22100000
# addi $s1, $s1, 0           00100010001100010000000000000000          0x22310000

##### loop:
# sub $a0, $a0, $t6         00000000100011100010000000100010           0x008E2022
# slt $t7, $a0, $t7         00000000100011110111100000101010           0x008F782A
# beq $t7, $t4, value       00010001111011000000000000000100           0x11EC0004
# addi $t6, $t6, 2          00100001110011100000000000000010           0x21CE0002
# addi $s1, $s1, 1          00100010001100010000000000000001           0x22310001
# beq $t7, $t5, loop        00010001111011010000000000000110           0x11ED0006

##### value:
# add $v0,$v0, $s1          00000000010100010001000000100000           0x00511020


#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################

#************************************************************************************************
#######             THE CONTROL UNIT        #######
#************************************************************************************************
## Type   Op[5:0]  Instruction        RegDst     ALUSrc    MemtoReg     RegWrite     MemRead   MemWrite   Branch      Jump       ALUOp[1:0]
##                 setup_r:
#  I      8(001000)       addi $a0, $a0, 34         0          1         0            1             0          0        0         0           00(+)
#  I      8(001000)       addi $t7, $t7, 0          0          1         0            1             0          0        0         0           00(+)
#  I      8(001000)       addi $t6, $t6, 1          0          1         0            1             0          0        0         0           00(+)
#  I      8(001000)       addi $t5, $t5, 0          0          1         0            1             0          0        0         0           00(+)
#  I      8(001000)       addi $t4, $t4, 1          0          1         0            1             0          0        0         0           00(+)
#  I      8(001000)       addi $s0, $s0, 0          0          1         0            1             0          0        0         0           00(+)
#  I      8(001000)       addi $s1, $s1, 0          0          1         0            1             0          0        0         0           00(+)

##                   loop:
#  R    0(000000)         sub $a0, $a0, $t6       1        0           0            1          0           0        0         0            1x
#  R    0(000000)        slt $t7, $a0, $t7       1        0           0            1          0           0        0         0            1x
#  I    8(000100)         beq $t7, $t4, value     x        0           x            0          0           0        1         0           01(-)
#  I    8(001000)         addi $t6, $t6, 2        0        1           0            1          0           0        0         0           00(+)
#  I    8(001000)         addi $s1, $s1, 1        0        1           0            1          0           0        0         0           00(+)
#  I    8(000100)         beq $t7, $t5, loop      x        0           x            0          0           0        1         0           01(-)
##                  value:
# R     0(000000)      add $v0, $s1, $v0          1        0           X            1          0           0        0          0           1x

#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################

#************************************************************************************************
#######             THE ALU        #######
#************************************************************************************************
## Type   ALUOp[1:0]  Instruction            ALUControl[2:0]                ALUOperation
##                 setup_r:
#  I      00       addi $a0, $a0, 34          010                                +
#  I      00       addi $t7, $t7, 0           010                                +
#  I      00       addi $t6, $t6, 1           010                                +
#  I      00       addi $t5, $t5, 0           010                                +
#  I      00       addi $t4, $t4, 1           010                                +
#  I      00       addi $s0, $s0, 0           010                                +
#  I      00       addi $s1, $s1, 0           010                                +

##                   loop:
#  R      1x       sub $a0, $a0, $t6          110                                +
#  R      1x       slt $t7, $a0, $t7          111                                -
#  I      01       beq $t7, $t4, value        110                                -
#  I      00      addi $t6, $t6, 2            010                                +
#  I      00      addi $s1, $s1, 1            010                                +
#  I      01      beq $t7, $t5, loop          110                                -
##                  value:
# R       1x    add $v0, $s1, $v0             010                                +



#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################

#************************************************************************************************
#######             Data and control risks in the program carried out.
#######             Forwarding or stopping the pipeline
#************************************************************************************************

#****** Risks:
# Considering the three known types of error:
# *Read after Write (RAW) or true dependencie: Might be if there is a glitch, because it
# said that a data is modified when the same data is not finishing his first action.
# *Write after Read (WAR) or anti-dependency: Not considering as risk. Because
# there is no read of data an write at ~time
# *Write after Write (WAW) or output dependency: Possible if two write instructions is
# doing at the same place.

#***** Forwarding or stopping the pipeline
# If there is a problem the pipeline will stop because a data risks is happen.

#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################

#************************************************************************************************
#######             Dr Mips.
#######             ALU & FOWARDING
#************************************************************************************************

#****** Unyciclye
#************************************************************************************************
#######             THE CONTROL UNIT        #######
#************************************************************************************************
## Type     Instruction             Opcode    AluOp    ALuSrc     Branch        Jump  Memread
##                  setup_r:
#  I           addi $a0, $a0, 34      8          0        1         0             0     0
#  I           addi $t7, $t7, 0       8          0        1         0             0     0
#  I           addi $t6, $t6, 1       8          0        1         0             0     0
#  I           addi $t5, $t5, 0       8          0        1         0             0     0
#  I           addi $t4, $t4, 1       8          0        1         0             0     0
#  I           addi $s0, $s0, 0       8          0        1         0             0     0
#  I           addi $s1, $s1, 0       8          0        1         0             0     0

##                  loop:
#  R          sub $a0, $a0, $t6        0          2        0         0             0     0
#  R          slt $t7, $a0, $t7        0          2        0         0             0     0
#  I          beq $t7, $t4, value      4          1        1         0             0     0
#  I          addi $t6, $t6, 2         8          0        1         0             0     0
#  I          addi $s1, $s1, 1         8          0        1         0             0     0
#  I          beq $t7, $t5, loop       4          1        1         0             0     0
##                  value:
# R           add $v0, $s1, $v0        0          2        0         0             0     0



#************************************************************************************************
#######             THE ALU        #######
#************************************************************************************************
## Type     Instruction            Func               ALUOp        Operation
##                 setup_r:
#  I      addi $a0, $a0, 34         34                  0               2
#  I      addi $t7, $t7, 0          0                   0               2
#  I      addi $t6, $t6, 1          1                   0               2
#  I      addi $t5, $t5, 0          0                   0               2
#  I      addi $t4, $t4, 1          1                   0               2
#  I      addi $s0, $s0, 0          0                   0               2
#  I      addi $s1, $s1, 0          0                   0               2

##                   loop:
#  R      sub $a0, $a0, $t6         34                  2               6
#  R      slt $t7, $a0, $t7         42                  2               7
#  I      beq $t7, $t4, value        3                  1               6
#  I      addi $t6, $t6, 2           2                  0               2
#  I      addi $s1, $s1, 1           1                  0               2
#  I      beq $t7, $t5, loop         58                 1               6
##                  value:
# R       add $v0, $s1, $v0         32                   2               2


#************************************************************************************************
#######             Data and control risks in the program carried out.
#######             Forwarding or stopping the pipeline
#************************************************************************************************
# ***** Risks
# Considering the three known types of error:
# *Read after Write (RAW) or true dependencie: Might be if there is a glitch, because it
# said that a data is modified when the same data is not finishing his first action.
# *Write after Write (WAW) or output dependency: Possible if two write instructions is
# doing at the same place.

# ***** Forwarding or stopping the pipeline
# It can be analyzed that according to the type of pipe the
# operation is not carried out as expected since it presents
# errors such as those previously commented. The result was less than expected


#---------------------------------            ---------------------------
#---------------------------------            ---------------------------
#---------------------------------            ---------------------------
#---------------------------------            ---------------------------
#---------------------------------            ---------------------------
#---------------------------------            ---------------------------
#---------------------------------            ---------------------------
#---------------------------------            ---------------------------


#***** Segmented:
#************************************************************************************************
#######             THE CONTROL UNIT        #######
#************************************************************************************************
## Type     Instruction             ALUSrc    MemtoReg    MemRead     Branch         ALUOp[1:0]   Opcode
##                  setup_r:
#  I           addi $a0, $a0, 34    0             0           0         0               2           0
#  I           addi $t7, $t7, 0     0             0           0         0               1           8
#  I           addi $t6, $t6, 1     0             0           0         0               1           8
#  I           addi $t5, $t5, 0     0             0           0         0               1           8
#  I           addi $t4, $t4, 1     0             0           0         0               1           8
#  I           addi $s0, $s0, 0     0             0           0         0               1           8
#  I           addi $s1, $s1, 0     0             0           0         0               1           8

##                  loop:
#  R          sub $a0, $a0, $t6     0             0           0         0               1           8
#  R          slt $t7, $a0, $t7     0             0           0         0               2           0
#  I          beq $t7, $t4, value   0             0           0         0               2           0
#  I          addi $t6, $t6, 2      0             0           0         1               1           4
#  I          addi $s1, $s1, 1      1             0           0         0               0           8
#  I          beq $t7, $t5, loop    1             0           0         0               0           8
##                  value:
# R           add $v0, $s1, $v0     0             0           0         1               1           4

#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################

#************************************************************************************************
#######             THE ALU        #######
#************************************************************************************************
## Type     Instruction            Func               ALUOp        Operation
##                 setup_r:
#  I      addi $a0, $a0, 34         0                   0               2
#  I      addi $t7, $t7, 0          0                   2               0
#  I      addi $t6, $t6, 1          1                   0               2
#  I      addi $t5, $t5, 0          34                  0               2
#  I      addi $t4, $t4, 1          0                   0               2
#  I      addi $s0, $s0, 0          0                   0               2
#  I      addi $s1, $s1, 0          1                   0               2

##                   loop:
#  R      sub $a0, $a0, $t6         0                   0               2
#  R      slt $t7, $a0, $t7         0                   0               2
#  I      beq $t7, $t4, value       34                  2               6
#  I      addi $t6, $t6, 2          42                  2               7
#  I      addi $s1, $s1, 1           3                  1               6
#  I      beq $t7, $t5, loop         2                  0               2
##                  value:
# R       add $v0, $s1, $v0         1                   0               2

#************************************************************************************************
#######             Data and control risks in the program carried out.
#######             Forwarding or stopping the pipeline
#************************************************************************************************
# ***** Risks
# Considering the three known types of error:
# *Write after Write (WAW) or output dependency: Possible if two write instructions is
# doing at the same place.

# ***** Forwarding or stopping the pipeline
# It can be analyzed that according to the type of pipe the
# operation is not carried out as expected since it presents
# errors such as those previously commented. The result was more than expected
