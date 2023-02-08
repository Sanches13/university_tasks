section .bss
 x resb 16    ;выделяем 16 байт для строки, которую вводит пользователь
 y resb 1     ;выделяем 1 байт для y
section .data
 array db '7', '4', '0', '5', '1', '8', '9', '3', '2', '6'   ;случайная подстановка

section .text:
 global _start
_start:
 mov eax, 3     ;считываем строку, которую вводит пользователь, записываем её в x
 mov ebx, 0 
 mov ecx, x
 mov edx, 16
 int 0x80 
 
 mov ecx, 16    ;помещаем в ecx длину введённой строки
 mov edi, x     ;помещаем в edi адрес введённой строки
point:
 push ecx           ;кладём в стек значение регистра ecx 
 mov ebx, array     ;помещаем в ebx адрес подстановки
 mov al, [edi]      ;помещаем в al значение, которое находится по адресу в edi
 sub al, 0x30       ;преобразуем символ в число
 xlatb              ;xlatb преобразует байт в регистре al на байт из нашей подстановки, адрес которой находится в ebx
 mov [y], al     ;помещаем в переменную y значение из регистра al
 mov eax, 4      ;выводим значение переменной y на экран
 mov ebx, 1
 mov ecx, y
 mov edx, 1
 int 0x80
 
 inc edi        ;увеличиваем значение edi, то есть переходим к следующему символу введённой строки
 pop ecx        ;достаём из стека значение ecx
 loop point     ;пока оно не равно нулю, переходим к метке point и повторяем действия
   
 mov eax, 1    ;завершаем программу
 mov ebx, 0
 int 0x80 
