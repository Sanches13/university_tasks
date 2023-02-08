section .bss 
 fd resb 4
 gamma resb 4
 char resb 1
 ind_gamma resb 4

section .text:
 global _start
_start:

 pop ebx 
 pop ebx
 pop ebx
 mov [gamma], ebx
 pop ebx
 
 mov eax, 5
 mov ecx, 2
 mov edx, 0
 int 0x80

 mov eax, 0
 mov [ind_gamma], eax

point:
 mov eax, 3
 mov ebx, [fd]
 mov ecx, char
 mov edx, 1
 int 0x80

 cmp eax, 0
 je exit

 mov esi, [gamma]
 mov eax, [ind_gamma]
 add esi, eax
 lodsb
 mov bl, [char]
 xor al, bl
 mov [char], al

 mov eax, 4
 mov ebx, [fd]
 mov ecx, char
 mov edx, 1
 int 0x80

 mov eax, [ind_gamma]
 inc eax
 cmp eax, 4
 je equal
 mov [ind_gamma], eax
 jmp point

equal:
 mov eax, 0 
 mov [ind_gamma], eax
 jmp point

exit:
 mov eax, 6
 mov ebx, [fd]
 int 0x80

 mov eax, 1
 mov ebx, 0
 int 0x80
