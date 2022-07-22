;Blanco_Singh_caeaser.asm
;Dinora Blanco   | EQ36698
;Gurjinder Singh | BY81697

;Ceasar Cipher program | Project 3 Spring 2022
;Program takes in 2 inputs, an interger, between 1-25, and a string, between 30-120 characters.
;It checks that the inputs are within the specified range. 
;The program then shifts the string by n times and outputs the shifted string.
;Shift means turning 'A' to 'B' with a shift of 1 and 'A' to 'C' with a shift of 2.

;We commented out our checks for the shift value as they were causing segfaults

        section .data

;initializing variables with print statements
shift_value:	 db "Enter shift value: ", 0	
len_sv           equ $-shift_value

invalid_shift_msg:   db "Error: Please enter a shift value between 0-25", 0
len_is           equ $-invalid_shift_msg

original_msg:    db "Enter original message: ", 0
len_om           equ $-original_msg

invalid_msg:     db "Error: Please enter a message between 30-120 characters", 0
len_im           equ $-invalid_msg

current_msg:     db "Current message: ", 0
len_cm           equ $-current_msg

encrypted_msg:   db "Encryption: ", 10
len_em           equ $-encrypted_msg

;setting the format
print_fmt:       db "%s", 0          
input_fmt:       db "%d", 0          
float_fmt:       db "%f", 0

        section .bss
input            resb   4           ;reserving bytes for input & buffers
shift_buf        resb   1000
msg_buf          resb   1000

        section .text
        
        global main		

main:				
        push    rbp			
	    mov	r8, 0                   ;Used for keeping track of shifts
        call    user_input

user_input:                         ;getting user inputs
        mov     rax, 1              ;shift value prompt
        mov     rdi, 1
        mov     rsi, shift_value
        mov     rdx, len_sv
        syscall

        mov     rax, 0               ;need 3 bytes for 2 numbers and \n char
        mov     rdi, 0
        mov     rsi, shift_buf          
        mov     rdx, 4              
        syscall                      ;Shift input

        ;cmp     rsi, 2
        ;je      singleshift         ;if shift value len is 1 (2 becaus of \n)
        ;cmp     rdx, 3
        ;je      doubleshift         ;if shift value len is 2 (3 becaus of \n)
        ;call    check_shift
        
        mov     rax, 1               ;original message prompt
        mov     rdi, 1
        mov     rsi, original_msg
        mov     rdx, len_om
        syscall
                                     ;To get from ascii to #'s, subtract 48
        mov     rax, 0
        mov     rdi, 0
        mov     rsi, msg_buf
        mov     rdx, 1000
        syscall                      ;Message input

        mov     rax, 1
        mov     rdi, 1
        mov     rsi, current_msg
        mov     rdx, len_cm
        syscall                      ;Print current message

        mov     rax, 1
        mov     rdi, 1
        mov     rsi, msg_buf
        mov     rdx, 1000
        syscall                      ;Print original message

        mov     rax, 1
        mov     rdi, 1
        mov     rsi, encrypted_msg
        mov     rdx, len_em
        syscall                      ;Print encrypted message

        call    exit
        
exit:                                ;Required exit function
        mov     rax, 60
        xor     rdi, rdi
        syscall

;singleshift:                      ;final value should be stored in r8
;        xor     r9, r9            ;r9 is used for storing the shift value
;        mov     r9b, [shift_buf]     
;        sub     r9b, 48
;        mov     r10, r9  
;
;doubleshift:
;        mov     r8, shift_buf
;        xor     r9, r9
;        mov     r9b, [r8]
;        cmp     r9b, '-'
;        je      shift_error
;        sub     r9b, 48
;        cmp     r9b, 2
;        jg      shift_error
;        jl      lessthan20
;        inc     r8
;        mov     r9b, [r8]
;        sub     r9b, 48
;        cmp     r9b, 5
;        jg      shift_error
;        add     r10, r9
;lessthan20:
;        inc     r8
;        mov     r9b, [r8]
;        sub     r9b, 48
;        add     r10, r9
;        cmp     r8, 20

check_shift:
        cmp     r8, 0
        jl      invalid_shift_msg
        cmp     r8, 25
        jg      invalid_shift_msg

shift_error:
        mov     rax, 1              ;shift value prompt
        mov     rdi, 1
        mov     rsi, invalid_shift_msg
        mov     rdx, len_is
        syscall
