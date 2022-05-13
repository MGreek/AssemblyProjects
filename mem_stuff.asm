bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    S db 1, 5, 3, 8, 2, 9
    l equ $ - S
    
    D1 times l db 0
    i1 dd 0
    
    D2 times l db 0
    i2 dd 0
    
; our code starts here
segment code use32 class=code
    start:
        ; Uebung 11
        ; S ist eine Folge von Bytes
        ; D1 enthaelt alle gerade Zahlen von S
        ; D2 enthaelt alle ungerade Zahlen von S
        
        mov ecx, l
        mov esi, 0
        jecxz loop_end
        loop_start:
            test [S + esi], byte 01h ; Pruefe die Paritaet der Zahl auf die aktuelle Stelle 
            jz if_even ; Spring zu dem entspraechenden Code wo man gerade Zahlen handelt
            
            ; D1[i1++] = S[esi++]
            mov edi, [i2]
            mov al, [S + esi]
            mov [D2 + edi], al
            inc dword [i2]
            inc esi
        loop loop_start
        jecxz loop_end
            if_even:
                ; D2[i2++] = S[esi++]
                mov edi, [i1]
                mov al, [S + esi]
                mov [D1 + edi], al
                inc dword [i1]
                inc esi
        loop loop_start
        loop_end:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
