
#                 IE0321 Digital Computer Structures I
#                        Belinda Brown Ramirez
#                        timna.brown@ucr.ac.cr
#                             May, 2020


# It is for a MIPS architecture

#  It consists of a function in Mips that receives in $ a0 the area of the
# base and in $ a1 the height, in $ v0 it returns the quotient of the volume
# of the pyramid and in $ v1 the remainder.

# The product is not supposed to exceed 32 bits.

# Area of a pyramid is:
  # A = 1/3*A_base*height


# Cleaning spaces
clean:
  li $t0, 3
  li $t1, 0 # Will store height
  li $t2, 0 # Will store A_base
  li $s0, 0 # Will store A_base*height

begin:
  lw $t1, 0($a1) # Load height
  lw $t2, 0($a2) # Load A_base

multi:
  multu $t2, $t1 # A_base*height
  mflo $v0     # Move quotient
  addu $s0, $zero, $v0 # save  multiply result

divide:
  li $v0, 0 # Save quotient
  li $v1, 0 # Save remainder
  divu $s0, $t0 # A_base*height/3
  mfhi $v1    # Move remainder
	addu $v1, $zero, $v1 # Save remainder
	mflo $v0     # Move quotient
	addu $v0, $zero, $v0 # save quotient

end:
