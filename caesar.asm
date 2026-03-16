# ==========================================================
# Application: String Encryption Tool (Caesar Cipher using mips)
# Author: kasiruse
# Description: Implements a cyclic shift cipher for alphanumeric strings.
# ==========================================================

.data
    # Input data and buffer
    input_buffer:  .asciiz "Lz3k o6k 5fujqhl5v"  # Source string to be processed
    key_value:     .word 8                      # Rotation offset
    
    # UI Messages
    header_msg:    .asciiz "Original String: "
    result_msg:    .asciiz "\nEncrypted Output: "

.text
.globl main

main:
    # Display the initial message
    li $v0, 4
    la $a0, header_msg
    syscall
    
    # Print the source string before encryption
    la $a0, input_buffer
    syscall

    # Prepare arguments for the processing function
    la $a0, input_buffer      # Pointer to string
    lw $a1, key_value         # Load the shift amount
    
    # Execute the core encryption logic
    jal ceasar

    # Display the success message
    li $v0, 4
    la $a0, result_msg
    syscall

    # Print the final modified string
    li $v0, 4
    la $a0, input_buffer
    syscall

    # Terminate program execution
    li $v0, 10
    syscall

# ----------------------------------------------------------
# Core Logic
# ----------------------------------------------------------

ceasar:
	li $t4,10 # Initialize constants
	li $t5,26 
	li $t0,0 # Index
while: # Check each character and determine the corresponding action.
	add $t6,$t0,$a0
	lb $t1,0($t6)	# $t1 is the $t0-th character of the text.
	beq $t1,$0,endwhile
	# Determine if $t1 is a digit, uppercase, or lowercase letter:
	slti $t2,$t1,58 
	sgt $t3,$t1,47
	and $t2,$t2,$t3
	bne $t2,$0,digit # Digit ASCII: from 48 to 57
	slti $t2,$t1,91
	sgt $t3,$t1,64
	and $t2,$t2,$t3
	bne $t2,$0,capital # Uppercase ASCII: from 65 to 90
	slti $t2,$t1,123
	sgt $t3,$t1,96
	and $t2,$t2,$t3
	bne $t2,$0,small # Lowercase ASCII: from 97 to 122
	j nodw
digit:
	sub $t2, $t1, 48
	add $t2,$t2,$a1
	div $t2,$t4
	mfhi $t2 
	addi $t2,$t2,48 # Cyclic shift (mod 10)
	sb $t2,0($t6)
	j nodw
capital:
	sub $t2, $t1, 65
	add $t2,$t2,$a1
	div $t2,$t5
	mfhi $t2
	addi $t2,$t2,65 # Cyclic shift (mod 26)
	sb $t2,0($t6)
	j nodw
small:
	sub $t2, $t1, 97
	add $t2,$t2,$a1
	div $t2,$t5
	mfhi $t2
	addi $t2,$t2,97 # Cyclic shift (mod 26)
	sb $t2,0($t6)
nodw:
	addi $t0,$t0,1 # Index++
	j while
endwhile:
	jr $ra
