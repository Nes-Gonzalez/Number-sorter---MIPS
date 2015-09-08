
.data
	.align 2
	array: .space 40 #10 words
	size: .word 10
	please: .asciiz "Please input a number: "
	nl: .asciiz "\n"
.text
.globl main

#t0 is our loop counter
#t1 is user input storage
#t2 is used for array offset
#t3 is current array element
#t4 is our swap counter
#t5 is our second array element used for compairisons
#t6 is n-1


#s0 is our array address
#s1 is our arary size
#s3 is 4 (used to multiply and move along array)

#a1 is argument that stores array
#a2 is argument that stores size

main:
	la $s1,size	#getting size
	lw $s1,0($s1)	#getting size int value
	li $s3,4
	la $s0,array #getting array

	move $a1,$s0
	move $a2,$s1
	jal fillArray	#calling fill array

	move $a1,$s0
	move $a2,$s1
	jal bubbleSort

	move $a1,$s0
	move $a2,$s1
	jal printArray

	li $v0,10	#exit
	syscall
#---------------------------------------------------------
fillArray:
	add $sp,$sp,-4 #storing arugments
	sw $a1,0($sp)
	add $sp,$sp,-4
	sw $a2,0($sp)
	add $sp,$sp,-4
	sw $ra,0($sp)
	li $t0,0 #resetting counter
	fillLoop:
		beq $t0,$a2,fillBreak #for 1 to 10
		li $v0,4
		la $a0,please	#string output
		syscall

		li $v0,5	#getting user input
		syscall

		move $t1,$v0	#storing user input

		mul $t2,$t0,$s3	#getting offset and storing input
		add $t3,$t2,$a1
		sw $t1,0($t3)

		add $t0,$t0,1 #adding 1 to counter
		j fillLoop

	fillBreak:
		lw $ra,0($sp) #restoring ra
		add $sp,$sp,4
		lw $a2,0($sp) #restoring arguments
		add $sp,$sp,4
		lw $a1,0($sp)
		add $sp,$sp,4
		jr $ra

#------------------------------------------------------
printArray:
	add $sp,$sp,-4 #storing arugments
	sw $a1,0($sp)
	add $sp,$sp,-4
	sw $a2,0($sp)
	add $sp,$sp,-4
	sw $ra,0($sp)
	li $t0,0 #resetting counter

	printLoop:
		beq $t0,$a2,printBreak

		mul $t2,$t0,$s3 #getting current offest
		add $t3,$t2,$a1
		lw $t1,0($t3) #loading element at current offset

		li $v0,1
		move $a0,$t1	#printing element
		syscall

		li $v0,4
		la $a0,nl	#new line string
		syscall

		add $t0,$t0,1 #adding 1 to counter
		j printLoop

	printBreak:
		lw $ra,0($sp) #restoring ra
		add $sp,$sp,4
		lw $a2,0($sp) #restoring arguments
		add $sp,$sp,4
		lw $a1,0($sp)
		add $sp,$sp,4
		jr $ra

#--------------------------------------------------------
bubbleSort:
	add $sp,$sp,-4 #storing arugments
	sw $a1,0($sp)
	add $sp,$sp,-4
	sw $a2,0($sp)
	add $sp,$sp,-4
	sw $ra,0($sp)
	li $t4,1 #setting $t4 to 1 to force first DO
	li $t0,0 #resetting counter
	add $t6,$a2,-1 #our n-1

	check:		#outer for loop that breaks when array is sorted
		beq $t4,0,bubbleBreak

		li $t4,0 #reseting swap counter and loop counter
		li $t0,0

		loop:
			beq $t0,$t6,check	#inner for loop performs sort

			mul $t2,$t0,$s3 #getting offset
			add $t3,$t2,$a1
			lw $t1,0($t3)	#loading current element and next element
			lw $t5,4($t3)
			bgt $t1,$t5,swap #checking if swap is needed
			add $t0,$t0,1
			j loop
			swap:
				sw $t5,0($t3)	#performing swap
				sw $t1,4($t3)
				add $t4,$t4,1 	#adding 1 to swap counter
				add $t0,$t0,1
				j loop
	bubbleBreak:
		lw $ra,0($sp) #restoring ra
		add $sp,$sp,4
		lw $a2,0($sp) #restoring arguments
		add $sp,$sp,4
		lw $a1,0($sp)
		add $sp,$sp,4
		jr $ra
