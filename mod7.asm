bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

extern fopen
import fopen msvcrt.dll

extern fprintf
import fprintf msvcrt.dll

extern fclose
import fclose msvcrt.dll

extern scanf
import scanf msvcrt.dll

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    
    x RESD 1
    handle RESD 1
    format_scanf db "%d", 0
    format_fprintf db "%d ", 0
    path db "datei.txt", 0
    mode db "w", 0
    
; our code starts here
segment code use32 class=code
    start:
        ; II. 10.
        ; Dateiname definiert in DS
        ; Lese Zahlen von die Tastatur und fuege, die durch 7 teilbare, in der Datei hinzu
        
        push dword mode
        push dword path
        call [fopen]
        add esp, 4 * 2
        mov [handle], eax ; handle ist der "file descriptor"
        
    loop_start:
        push dword x
        push dword format_scanf
        call [scanf]
        add esp, 4 * 2
        cmp dword [x], 0 ; Program beenden wenn x = 0
        jz loop_end
        mov edx, 0
        mov eax, [x]
        mov ecx, 7
        idiv ecx
        cmp edx, 0
        jnz loop_start ; Schreibe x in die Datei wenn x % 7 = 0
        push dword [x]
        push dword format_fprintf
        push dword [handle]
        call [fprintf]
        add esp, 4 * 3
        jmp loop_start
    loop_end:
        
        push dword [handle]
        call [fclose]
        add esp, 4 * 1
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
