#                Digital computer structures I
#                    Belinda Brown Ramirez
#                        May, 2020
#                    timna.brown@ucr.ac.cr

# Based on the high-level code:

# for(i=0; i<100; i++)
# {
#   if(A[i]<=0)
#      A[i]=A[i]*-1;
#   else
#      A[i]=A[i]-1;
# }

# Mips assembly code
# Considerations:
# 1. Register i is mapped to $t0 and array A is mapped to register $S0
# 2. The program starts at address 0x00700000
# 3. Multiplying a negative integer by -1 is the same as complementing this A2.
# 4. Use the table with the instruction codes
# 5. Register $t0 has the code 8, $t1 9, $t2 10, and $s0 16.

.text
main:
    li $t1, 100                 # In $t1 we have a constant of 100 li is of load immediate
    li $t0, 0                   # In $t0 we have the counter i, i = 0
loop:                           # Started the for
    beq $t0, $t1, endfor        # for A[i] <= 100 endfor
    addi $t2,$t2, 0xFFFF        # A new arrangement is made to save the results
    beq $s0, $t0, endif         # if A[i] <= 0 -- conditional
    sub $t2, $t0, 1             # A[i] = A[i]-1
    j endif
then:
    nor $t2, $t2,$0              # 2's complement 
    sw $t2, 0($t0)              # Save in $t2 A[i] =  A[i]*(-1)
    endif:
    addi $t0,$t0, 1             # i ++
    j loop                      # jump loop of for
    endfor:                     # end loop




#                   Memory map of the machine language program with all hexadecimal values


# ### GENERAL TABLE

# Instruction	                     TYPE	         opcode	     rs	     rt	       rd/Immediate      shamt     	func
# li $t1, 100                PSEUDOINSTRUCTION SET	     					 	  0
# li $t0, 0                  PSEUDOINSTRUCTION SET							  0
# beq $t0, $t1, endfor              I         		  0x04       8        9        endfor             0    		 NA
# addi $t2,$t2, 0xFFFF              I            	  0x08       10      10        0xFFFF             0    		 NA
# beq $s0, $t0, endif               I            	  0x04       16       8        endif              0   		 NA
# sub $t2, $t0, 1                   R              	  0x00       10       8           1               0   		 0x22
# j endif                           J             	  0x02                          while             0    		 NA
# nor $t2, $t0,$t0                  R             	  0x00       10       8          8                0   		 0x27
# sw $t2, 0($t0)                    I              	  0x2B       10       8                           0   		 NA
# addi $t0,$t0, 1                   I               	  0x08       8        8          1                0   		 NA
# j loop                            J                     0x02                         while              0    		 NA


# # TABLA HEXADECIMAL

# Instruction	                     TYPE	         opcode	     rs	     rt	       rd/Immediate      shamt     	func
# li $t1, 100                PSEUDOINSTRUCTION SET	     					 	 0x00
# li $t0, 0                  PSEUDOINSTRUCTION SET							 0x00
# beq $t0, $t1, endfor              I         		  0x04      0x08     0x09        endfor          0x00    		 NA
# addi $t2,$t2, 0xFFFF              I            	  0x08      0xAA     0xAA       0xFFFF           0x00    		 NA
# beq $s0, $t0, endif               I            	  0x04      0xFF     0x08        endif           0x00   		 NA
# sub $t2, $t0, 1                   R              	  0x00      0xAA     0x08         0x01           0x00   		 0x22
# j endif                           J             	  0x02                          while            0x00    		 NA
# nor $t2, $t0,$t0                  R             	  0x00      0xAA    0x08         0x08            0x00   		 0x27
# sw $t2, 0($t0)                    I              	  0x2B      0xAA    0x08                         0x00   		 NA
# addi $t0,$t0, 1                   I               	  0x08      0x08    0x08         0x01            0x00   		 NA
# j loop                            J                     0x02                          while            0x00    		 NA
