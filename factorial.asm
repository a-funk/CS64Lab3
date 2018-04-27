# xSpim Demo Program
# 
#   CPE 315
#   fall 2001
#
# By: Dan Stearns
# Date:  
# Modifications: 
#	4/10/03 knico Tabbed code
#	4/10/03 knico Modified to use s registers instead of t registers
#           
#
# declare global so programmer can see actual addresses.

#  Data Area - allocate and initialize variables
.data

prompt:
	.asciiz "Enter the number:\n"
newline:
	.asciiz "\n"

#Text Area (i.e. instructions)
.text

main:
	# TODO: Write your code here
	# Print prompt
	li $v0, 4
	la $a0, prompt
	syscall

	#Get Input
	li $v0, 5
	syscall
	move $t0, $v0
	li $s0, 1
fact:
	beq $t0, $zero, exit_loop
	mult $s0, $t0
	mflo $s0

	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	sub $t0, $t0, 1
	j fact
exit_loop:
	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 4
	la $a0, newline
	syscall
exit:

	# Exit
	ori     $v0, $0, 10
	syscall
