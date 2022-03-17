## addEm.asm
## program to add two integers
##
        .text
        .globl  main

main:
        #Registers as defined in my mips pipeline!
        li    $t0,0
        li    $t1,1
        li    $t2,2
        li    $t3,3
        li    $t4,4
        li    $t5,5
        li    $t6,6
        li    $t7,7
        li    $t8,8
        li    $t9,9
        #Start of random assembly program
        nor $t0,$t3,$t5
        and $t3,$t8,$t1
        nor $t3,$t6,$t7
        sll $t7,$t0,$t1
        srl $t3,$t6,$t2
        srl $t0,$t6,$t5
        sll $t3,$t7,$t9
        sll $t9,$t1,$t3
        srl $t4,$t7,$t6
        srl $t0,$t8,$t5
        sub $t0,$t4,$t8
        srl $t4,$t7,$t7
        add $t8,$t3,$t9
        nor $t9,$t3,$t5
        or $t8,$t8,$t5
        sll $t8,$t8,$t6
        slt $t7,$t7,$t3
        sub $t1,$t2,$t0
        nor $t7,$t4,$t5
        or $t7,$t2,$t1
        sll $t5,$t2,$t2
        or $t0,$t1,$t1
        slt $t7,$t5,$t6
        slt $t4,$t3,$t0
        nor $t6,$t6,$t7
        nor $t5,$t6,$t3
        srl $t4,$t6,$t4
        srl $t8,$t7,$t6
        or $t3,$t0,$t7
        or $t7,$t8,$t1
        add $t7,$t2,$t9
        nor $t6,$t5,$t0
        srl $t7,$t1,$t1
        or $t4,$t0,$t1
        sub $t7,$t0,$t8
        or $t6,$t2,$t0
        or $t9,$t6,$t4
        or $t1,$t9,$t0
        sll $t6,$t1,$t4
        or $t0,$t5,$t4
        slt $t9,$t5,$t5
        slt $t8,$t7,$t3
        slt $t6,$t3,$t7
        nor $t4,$t5,$t8
        srl $t5,$t5,$t0
        and $t3,$t5,$t8
        sub $t9,$t9,$t3
        sub $t2,$t7,$t2
        slt $t4,$t3,$t5
        add $t8,$t1,$t5
        sub $t9,$t1,$t6
        nor $t3,$t3,$t9
        add $t4,$t7,$t3
        sll $t9,$t5,$t0
        and $t8,$t3,$t9
        add $t6,$t1,$t7
        add $t9,$t9,$t5
        add $t3,$t2,$t0
        nor $t6,$t2,$t6
        nor $t4,$t1,$t3
        #End of generated random assembly program
        #open file
        li $v0, 13         # open file syscall code = 13
        la $a0, file       # get the file name
        li $a1, 1          # file flag for write (1)
        syscall
        move $s1, $v0      # Save the file descriptor $s0 = file

        #Write the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        #li $s2, 8          #Save the number of nibbles to loop through
        #addi $s2, 48       # Save 48, use this as your number to add for ascii
        #addi $s3, 55       # If the shifted masked number is greater than 9

        #Write the hex value for $t1 to the registers.txt file

        li $s5, 9          # For hexadecimal digit check...











############################# Start of $t0 write ###############################

############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t0  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX_1  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC_1        #If hex digit is not greater than 9, then jump to decimal


HEX_1:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE_1          #Jump to write for writing nibble

DEC_1:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE_1:  la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t0  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2_1  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2_1        #If hex digit is not greater than 9, then jump to decimal


HEX2_1:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2_1          #Jump to write for writing nibble

DEC2_1:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2_1: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t0  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3_1  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3_1        #If hex digit is not greater than 9, then jump to decimal


HEX3_1:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3_1          #Jump to write for writing nibble

DEC3_1:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3_1:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t0  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4_1  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4_1        #If hex digit is not greater than 9, then jump to decimal


HEX4_1:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4_1          #Jump to write for writing nibble

DEC4_1:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4_1:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t0  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5_1  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5_1        #If hex digit is not greater than 9, then jump to decimal


HEX5_1:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5_1          #Jump to write for writing nibble

DEC5_1:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5_1:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t0  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6_1  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6_1        #If hex digit is not greater than 9, then jump to decimal


HEX6_1:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6_1          #Jump to write for writing nibble

DEC6_1:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6_1:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t0  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7_1  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7_1        #If hex digit is not greater than 9, then jump to decimal


HEX7_1:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7_1          #Jump to write for writing nibble

DEC7_1:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7_1:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t0  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8_1  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8_1        #If hex digit is not greater than 9, then jump to decimal


HEX8_1:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8_1          #Jump to write for writing nibble

DEC8_1:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8_1: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall



        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


############################# End of $t0 write #################################







############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t1  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC        #If hex digit is not greater than 9, then jump to decimal


HEX:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE          #Jump to write for writing nibble

DEC:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE:  li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t1  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2        #If hex digit is not greater than 9, then jump to decimal


HEX2:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2          #Jump to write for writing nibble

DEC2:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t1  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3        #If hex digit is not greater than 9, then jump to decimal


HEX3:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3          #Jump to write for writing nibble

DEC3:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t1  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4        #If hex digit is not greater than 9, then jump to decimal


HEX4:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4          #Jump to write for writing nibble

DEC4:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t1  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5        #If hex digit is not greater than 9, then jump to decimal


HEX5:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5          #Jump to write for writing nibble

DEC5:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t1  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6        #If hex digit is not greater than 9, then jump to decimal


HEX6:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6          #Jump to write for writing nibble

DEC6:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t1  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7        #If hex digit is not greater than 9, then jump to decimal


HEX7:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7          #Jump to write for writing nibble

DEC7:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t1  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8        #If hex digit is not greater than 9, then jump to decimal


HEX8:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8          #Jump to write for writing nibble

DEC8:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall




        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


########################### End of register hexadecimal write $t1 ##########################


############################# Start of $t2 write ###############################

############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t2  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX_2  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC_2        #If hex digit is not greater than 9, then jump to decimal


HEX_2:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE_2          #Jump to write for writing nibble

DEC_2:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE_2: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t2  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2_2  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2_2        #If hex digit is not greater than 9, then jump to decimal


HEX2_2:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2_2          #Jump to write for writing nibble

DEC2_2:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2_2: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t2  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3_2  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3_2        #If hex digit is not greater than 9, then jump to decimal


HEX3_2:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3_2          #Jump to write for writing nibble

DEC3_2:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3_2:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t2  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4_2  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4_2        #If hex digit is not greater than 9, then jump to decimal


HEX4_2:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4_2          #Jump to write for writing nibble

DEC4_2:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4_2:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t2  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5_2  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5_2        #If hex digit is not greater than 9, then jump to decimal


HEX5_2:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5_2          #Jump to write for writing nibble

DEC5_2:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5_2:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t2  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6_2  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6_2        #If hex digit is not greater than 9, then jump to decimal


HEX6_2:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6_2          #Jump to write for writing nibble

DEC6_2:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6_2:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t2  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7_2  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7_2        #If hex digit is not greater than 9, then jump to decimal


HEX7_2:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7_2          #Jump to write for writing nibble

DEC7_2:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7_2:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t2  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8_2  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8_2        #If hex digit is not greater than 9, then jump to decimal


HEX8_2:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8_2          #Jump to write for writing nibble

DEC8_2:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8_2: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall



        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


############################# End of $t2 write #################################

############################# Start of $t3 write ###############################

############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t3  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX_3  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC_3        #If hex digit is not greater than 9, then jump to decimal


HEX_3:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE_3          #Jump to write for writing nibble

DEC_3:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE_3: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t3  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2_3  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2_3        #If hex digit is not greater than 9, then jump to decimal


HEX2_3:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2_3          #Jump to write for writing nibble

DEC2_3:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2_3: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t3  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3_3  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3_3        #If hex digit is not greater than 9, then jump to decimal


HEX3_3:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3_3          #Jump to write for writing nibble

DEC3_3:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3_3:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t3  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4_3  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4_3        #If hex digit is not greater than 9, then jump to decimal


HEX4_3:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4_3          #Jump to write for writing nibble

DEC4_3:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4_3:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t3  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5_3  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5_3        #If hex digit is not greater than 9, then jump to decimal


HEX5_3:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5_3          #Jump to write for writing nibble

DEC5_3:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5_3:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t3  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6_3  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6_3        #If hex digit is not greater than 9, then jump to decimal


HEX6_3:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6_3          #Jump to write for writing nibble

DEC6_3:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6_3:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t3  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7_3  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7_3        #If hex digit is not greater than 9, then jump to decimal


HEX7_3:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7_3          #Jump to write for writing nibble

DEC7_3:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7_3:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t3  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8_3  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8_3        #If hex digit is not greater than 9, then jump to decimal


HEX8_3:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8_3          #Jump to write for writing nibble

DEC8_3:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8_3: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall



        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


############################# End of $t3 write #################################


############################# Start of $t4 write ###############################

############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t4  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX_4  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC_4        #If hex digit is not greater than 9, then jump to decimal


HEX_4:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE_4          #Jump to write for writing nibble

DEC_4:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE_4: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t4  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2_4  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2_4        #If hex digit is not greater than 9, then jump to decimal


HEX2_4:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2_4          #Jump to write for writing nibble

DEC2_4:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2_4: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t4  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3_4  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3_4        #If hex digit is not greater than 9, then jump to decimal


HEX3_4:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3_4          #Jump to write for writing nibble

DEC3_4:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3_4:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t4  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4_4  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4_4        #If hex digit is not greater than 9, then jump to decimal


HEX4_4:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4_4          #Jump to write for writing nibble

DEC4_4:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4_4:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t4  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5_4  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5_4        #If hex digit is not greater than 9, then jump to decimal


HEX5_4:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5_4          #Jump to write for writing nibble

DEC5_4:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5_4:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t4  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6_4  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6_4        #If hex digit is not greater than 9, then jump to decimal


HEX6_4:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6_4          #Jump to write for writing nibble

DEC6_4:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6_4:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t4  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7_4  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7_4        #If hex digit is not greater than 9, then jump to decimal


HEX7_4:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7_4          #Jump to write for writing nibble

DEC7_4:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7_4:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t4  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8_4  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8_4        #If hex digit is not greater than 9, then jump to decimal


HEX8_4:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8_4          #Jump to write for writing nibble

DEC8_4:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8_4: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall



        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


############################# End of $t4 write #################################


############################# Start of $t5 write ###############################

############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t5  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX_5  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC_5        #If hex digit is not greater than 9, then jump to decimal


HEX_5:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE_5          #Jump to write for writing nibble

DEC_5:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE_5: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t5  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2_5  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2_5        #If hex digit is not greater than 9, then jump to decimal


HEX2_5:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2_5          #Jump to write for writing nibble

DEC2_5:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2_5: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t5  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3_5  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3_5        #If hex digit is not greater than 9, then jump to decimal


HEX3_5:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3_5          #Jump to write for writing nibble

DEC3_5:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3_5:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t5  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4_5  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4_5        #If hex digit is not greater than 9, then jump to decimal


HEX4_5:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4_5          #Jump to write for writing nibble

DEC4_5:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4_5:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t5  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5_5  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5_5        #If hex digit is not greater than 9, then jump to decimal


HEX5_5:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5_5          #Jump to write for writing nibble

DEC5_5:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5_5:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t5  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6_5  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6_5        #If hex digit is not greater than 9, then jump to decimal


HEX6_5:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6_5          #Jump to write for writing nibble

DEC6_5:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6_5:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t5  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7_5  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7_5        #If hex digit is not greater than 9, then jump to decimal


HEX7_5:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7_5          #Jump to write for writing nibble

DEC7_5:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7_5:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t5  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8_5  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8_5        #If hex digit is not greater than 9, then jump to decimal


HEX8_5:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8_5          #Jump to write for writing nibble

DEC8_5:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8_5: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall



        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


############################# End of $t5 write #################################



############################# Start of $t6 write ###############################

############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t6  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX_6  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC_6        #If hex digit is not greater than 9, then jump to decimal


HEX_6:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE_6          #Jump to write for writing nibble

DEC_6:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE_6: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t6  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2_6  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2_6        #If hex digit is not greater than 9, then jump to decimal


HEX2_6:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2_6          #Jump to write for writing nibble

DEC2_6:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2_6: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t6  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3_6  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3_6        #If hex digit is not greater than 9, then jump to decimal


HEX3_6:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3_6          #Jump to write for writing nibble

DEC3_6:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3_6:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t6  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4_6  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4_6        #If hex digit is not greater than 9, then jump to decimal


HEX4_6:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4_6          #Jump to write for writing nibble

DEC4_6:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4_6:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t6  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5_6  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5_6        #If hex digit is not greater than 9, then jump to decimal


HEX5_6:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5_6          #Jump to write for writing nibble

DEC5_6:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5_6:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t6  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6_6  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6_6        #If hex digit is not greater than 9, then jump to decimal


HEX6_6:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6_6          #Jump to write for writing nibble

DEC6_6:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6_6:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t6  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7_6  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7_6        #If hex digit is not greater than 9, then jump to decimal


HEX7_6:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7_6          #Jump to write for writing nibble

DEC7_6:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7_6:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t6  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8_6  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8_6        #If hex digit is not greater than 9, then jump to decimal


HEX8_6:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8_6          #Jump to write for writing nibble

DEC8_6:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8_6: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall



        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


############################# End of $t6 write #################################


############################# Start of $t7 write ###############################

############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t7  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX_7  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC_7        #If hex digit is not greater than 9, then jump to decimal


HEX_7:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE_7          #Jump to write for writing nibble

DEC_7:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE_7: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t7  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2_7  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2_7        #If hex digit is not greater than 9, then jump to decimal


HEX2_7:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2_7          #Jump to write for writing nibble

DEC2_7:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2_7: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t7  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3_7  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3_7        #If hex digit is not greater than 9, then jump to decimal


HEX3_7:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3_7          #Jump to write for writing nibble

DEC3_7:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3_7:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t7  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4_7  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4_7        #If hex digit is not greater than 9, then jump to decimal


HEX4_7:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4_7          #Jump to write for writing nibble

DEC4_7:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4_7:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t7  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5_7  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5_7        #If hex digit is not greater than 9, then jump to decimal


HEX5_7:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5_7          #Jump to write for writing nibble

DEC5_7:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5_7:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t7  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6_7  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6_7        #If hex digit is not greater than 9, then jump to decimal


HEX6_7:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6_7          #Jump to write for writing nibble

DEC6_7:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6_7:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t7  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7_7  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7_7        #If hex digit is not greater than 9, then jump to decimal


HEX7_7:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7_7          #Jump to write for writing nibble

DEC7_7:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7_7:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t7  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8_7  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8_7        #If hex digit is not greater than 9, then jump to decimal


HEX8_7:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8_7          #Jump to write for writing nibble

DEC8_7:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8_7: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall



        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


############################# End of $t7 write #################################


############################# Start of $t8 write ###############################

############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t8  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX_8  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC_8        #If hex digit is not greater than 9, then jump to decimal


HEX_8:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE_8          #Jump to write for writing nibble

DEC_8:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE_8: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t8  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2_8  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2_8        #If hex digit is not greater than 9, then jump to decimal


HEX2_8:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2_8          #Jump to write for writing nibble

DEC2_8:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2_8: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t8  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3_8  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3_8        #If hex digit is not greater than 9, then jump to decimal


HEX3_8:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3_8          #Jump to write for writing nibble

DEC3_8:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3_8:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t8  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4_8  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4_8        #If hex digit is not greater than 9, then jump to decimal


HEX4_8:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4_8          #Jump to write for writing nibble

DEC4_8:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4_8:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t8  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5_8  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5_8        #If hex digit is not greater than 9, then jump to decimal


HEX5_8:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5_8          #Jump to write for writing nibble

DEC5_8:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5_8:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t8  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6_8  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6_8        #If hex digit is not greater than 9, then jump to decimal


HEX6_8:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6_8          #Jump to write for writing nibble

DEC6_8:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6_8:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t8  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7_8  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7_8        #If hex digit is not greater than 9, then jump to decimal


HEX7_8:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7_8          #Jump to write for writing nibble

DEC7_8:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7_8:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t8  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8_8  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8_8        #If hex digit is not greater than 9, then jump to decimal


HEX8_8:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8_8          #Jump to write for writing nibble

DEC8_8:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8_8: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall



        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


############################# End of $t8 write #################################


############################# Start of $t9 write ###############################

############################# This is for Nibble 1 #############################

        li $s4, 0xF0000000 #Mask for the most significant hex value
        and $s4, $s4, $t9  #Isolate the most significant hex value
        srl $s4, $s4, 28   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX_9  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC_9        #If hex digit is not greater than 9, then jump to decimal


HEX_9:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE_9          #Jump to write for writing nibble

DEC_9:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE_9: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall


############################## This is for nibble 2 ##########################

        li $s4, 0x0F000000 #Mask for the most significant hex value
        and $s4, $s4, $t9  #Isolate the most significant hex value
        srl $s4, $s4, 24   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX2_9  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC2_9        #If hex digit is not greater than 9, then jump to decimal


HEX2_9:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE2_9          #Jump to write for writing nibble

DEC2_9:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE2_9: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall

############################## This is for nibble 3 #########################

         li $s4, 0x00F00000 #Mask for the most significant hex value
         and $s4, $s4, $t9  #Isolate the most significant hex value
         srl $s4, $s4, 20   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX3_9  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC3_9        #If hex digit is not greater than 9, then jump to decimal


HEX3_9:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE3_9          #Jump to write for writing nibble

DEC3_9:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE3_9:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 4 #########################

         li $s4, 0x000F0000 #Mask for the most significant hex value
         and $s4, $s4, $t9  #Isolate the most significant hex value
         srl $s4, $s4, 16   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX4_9  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC4_9        #If hex digit is not greater than 9, then jump to decimal


HEX4_9:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE4_9          #Jump to write for writing nibble

DEC4_9:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE4_9:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 5 #########################


         li $s4, 0x0000F000 #Mask for the most significant hex value
         and $s4, $s4, $t9  #Isolate the most significant hex value
         srl $s4, $s4, 12   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX5_9  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC5_9        #If hex digit is not greater than 9, then jump to decimal


HEX5_9:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE5_9          #Jump to write for writing nibble

DEC5_9:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE5_9:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 6 #########################

         li $s4, 0x00000F00 #Mask for the most significant hex value
         and $s4, $s4, $t9  #Isolate the most significant hex value
         srl $s4, $s4, 8   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX6_9  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC6_9        #If hex digit is not greater than 9, then jump to decimal


HEX6_9:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE6_9          #Jump to write for writing nibble

DEC6_9:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE6_9:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall



############################## This is for nibble 7 #########################


         li $s4, 0x000000F0 #Mask for the most significant hex value
         and $s4, $s4, $t9  #Isolate the most significant hex value
         srl $s4, $s4, 4   #Shift the masked value right 28 bits to make it least significant!
         bgt $s4, $s5, HEX7_9  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
         j   DEC7_9        #If hex digit is not greater than 9, then jump to decimal


HEX7_9:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
         j   WRITE7_9          #Jump to write for writing nibble

DEC7_9:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE7_9:  li $v0, 15         # write file syscall code = 15
         move $a0, $s1      # file descriptor
         la $s0, t1
         sw $s4, 0($s0) #Store $s0 in memory location t1
         la $a1, t1
         la $a2, 1
         syscall


############################## This is for nibble 8 #########################

        li $s4, 0x0000000F #Mask for the most significant hex value
        and $s4, $s4, $t9  #Isolate the most significant hex value
        srl $s4, $s4, 0   #Shift the masked value right 28 bits to make it least significant!
        bgt $s4, $s5, HEX8_9  #If hex digit is greater than 9, then branch to section to add 55 offset vs 48 offset
        j   DEC8_9        #If hex digit is not greater than 9, then jump to decimal


HEX8_9:    addi $s4, $s4, 55  #We just want to write $s4 to the file...
        j   WRITE8_9          #Jump to write for writing nibble

DEC8_9:    addi $s4, $s4, 48  #Format decimal value to asscii representation

WRITE8_9: li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $s0, t1
        sw $s4, 0($s0) #Store $s0 in memory location t1
        la $a1, t1
        la $a2, 1
        syscall



        #Add a new line to the file
        li $v0, 15         # write file syscall code = 15
        move $a0, $s1      # file descriptor
        la $a1, nl
        la $a2, 1
        syscall


############################# End of $t9 write #################################



        #close the file
        li $v0, 16         # close file syscall code = 16
        move $a0, $s1      # file descriptor to close
        syscall

        .data
val0:   .word   0x0
val1:   .word   0x1
val2:   .word   0xA
val3:   .word   0x3
val4:   .word   0x4
val5:   .word   0x5
file:   .asciiz "/Users/jm/Desktop/spim/registers.txt"
t1:     .word   0
nl:     .word   10
