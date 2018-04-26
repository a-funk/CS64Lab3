# xSpim MedianNumbers.asm program
# 
#

#  Data Area - allocate and initialize variables
.data

	# TODO: Complete these declarations / initializations

prompt_string:	.asciiz "Enter the next number:\n"

output_string:	.asciiz "Median: "



#Text Area (i.e. instructions)
.text
main:

	li  $v0, 4
	la	$a0, prompt_string
	syscall

    #Input first string
	li  $v0, 5
    syscall
    move    $t0, $v0	

    #Prompt for second string
	li	$v0, 4
	la	$a0, prompt_string
	syscall

    #Input second string
	li	$v0, 5
    syscall
    move    $t1, $v0	

    #Prompt for third string
	li	$v0, 4
	la	$a0, prompt_string
	syscall
    
    #Input third string
	li	$v0, 5
    syscall
    move  $t2, $v0
    
    j test_x_med_yxz

#Test x's
test_x_med_yxz:
    j x_less_z

x_less_z:
    blt $t0, $t2 x_great_y
    j test_x_med_zxy

x_great_y:
    bgt $t0, $t1, print_0
    j test_x_med_zxy

test_x_med_zxy:
    j x_great_z
    
x_great_z:
    bgt $t0, $t2, x_less_y
    j test_y_med_xyz
    
x_less_y:
    blt $t0, $t1, print_0
    j test_y_med_xyz

    
#Test y's	
test_y_med_xyz:
    j y_less_z

y_less_z:
    blt $t1, $t2 y_great_x
    j test_y_med_zyx

y_great_x:
    bgt $t1, $t0, print_1
    j test_y_med_zyx
    
test_y_med_zyx:
    j y_great_z
    
y_great_z:
    bgt $t1, $t2, y_less_x
    j test_z_med_xzy

y_less_x:
    blt $t1, $t0, print_1
    j test_z_med_xzy


#Test Z's
test_z_med_xzy:
    j z_less_y

z_less_y:
    blt $t2, $t1 z_great_x
    j test_z_med_yzx

z_great_x:
    bgt $t2, $t0, print_2
    j test_z_med_yzx

test_z_med_yzx:
    j z_great_y
    
z_great_y:
    bgt $t2, $t1, z_less_x

z_less_x:
    blt $t2, $t0, print_2

#EXIT PROGRAM
exit:
	# Exit
	ori     $v0, $0, 10
	syscall

print_0: 
    li $v0, 4
    la $a0, output_string
    syscall

	li	$v0, 1
	move    $a0, $t0
	syscall
    j exit

print_1: 
    li $v0, 4
    la $a0, output_string
    syscall

	li	$v0, 1
	move    $a0, $t1
	syscall
    j exit

print_2: 
    li $v0, 4
    la $a0, output_string
    syscall

	li	$v0, 1
	move    $a0, $t2
	syscall
    j exit
