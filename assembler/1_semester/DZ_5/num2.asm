section .bss 
 ind resb 4            ;выделяем 4 байта для ind
 string resb 4       ;выделяем 4 байта для переменной, в которую позже будет записан адрес строки
 symbol resb 4       ;выделяем 4 байта для переменной, в которую позже будет записан адрес символа
 array resb 10       ;выделяем 10 байт для области, в которой позже будет находиться искомое число
 size resb 4         ;выделяем 4 байта для size

section .text
 global _start
_start:
 pop ebx                   ;передаём строку и символ при запуске программы
 pop ebx
 pop ebx
 mov [string], ebx         ;адрес строки записываем в переменную string
 pop ebx
 mov [symbol], ebx         ;адрес символа записываем в переменную symbol

 mov eax, 0
 mov [ind], eax            ;обнуляем значения переменных ind и size
 mov [size], eax

point:                   ;создаём метку point
 mov edi, [symbol]       ;записываем в регистр edi адрес символа
 mov esi, [string]       ;записываем в регистр esi адрес строки
 cmp esi, edi            ;если адреса равны, ты мы достигли конца строки и нужно перейти к следующей метке(так как символ находится сразу же после последнего символа строки)
 je point2
 lodsb                   ;копируем 1 байт из памяти по адресу esi в регистр al
 
 mov [string], esi       ;помещаем в переменную string значение регистра esi, то есть адрес следующего символа строки
 mov bl, al              ;помещаем считанный байт строки в регистр bl
 mov esi, [symbol]       ;записываем в регистр esi адрес искомого символа
 lodsb                   ;копируем 1 байт из памяти по адресу esi в регистр al
 sub al, bl              ;вычитаем значение регистра bl из значения al
 cmp al, 0               ;если получили 0, то в регистрах находился один и тот же символ
 je equal                ;поэтому переходим к метке equal
 
 jmp point               ;иначе переходим обратно к метке point

equal:                   ;если найден искомый символ, то увеличиваем значение счётчика size на 1
 mov eax, [size]
 inc eax
 mov [size], eax
 jmp point               ;переходим обратно к метке point
  
point2:                  ;как только вся строка проанализирована, переходим к метке point2
 mov eax, [size]         ;помещаем в регистр eax количество вхождений искомого символа в строку
 cmp eax, 0              ;сравниваем это значение с 0, и в случае равенства переходим к метке point3
 je point3
                         ;для того, чтобы вывести найденное число, будем делить это число на 10 до тех пор, пока число не станет нулём
                         ;остаток от деления, то есть каждую цифру числа, будем записывать в array
 xor edx, edx            ;обнуляем значение регистра edx
 mov ebx, 10             ;помещаем в регистр ebx число 10
 div ebx                 ;делим значение регистра eax на значение регистра ebx

 mov [size], eax         ;помещаем частное в переменную size
 
 add edx, 0x30           ;остаток от деления, который теперь хранится в edx, переводим в число путем суммирования с 0x30
 mov eax, [ind]          ;в переменной ind хранится индекс, который должен иметь очередной символ в array
 mov edi, array          ;адрес array помещаем в edi
 add edi, eax            ;прибавляем индекс
 mov [edi], edx          ;помещаем полученную цифру числа по адресу в edi
 inc eax                 ;увеличиваем значение eax на 1, то есть значение нашего индекса
 mov [ind], eax          ;помещаем значение обратно в переменную ind

 jmp point2              ;переходим к метке point2
  
point3:                  ;теперь выведем полученное число на экран 
 mov edi, array          ;в регистр edi помещаем адрес array, где располагается число
 mov eax, [ind]          ;в регистр eax помещаем значение индекса ind
 cmp eax, 0              ;сравниваем значение с нулём
 jnge exit               ;если значение меньше нуля, то завершаем программу
 add edi, eax            ;прибаляем к адресу в edi значение индекса

 mov eax, [edi]          ;теперь помещаем в eax значение, расположенное по адресу в edi
 mov [symbol], eax       ;помещаем это значение в переменную symbol
 
 mov eax, 4              ;выводим значение на экран
 mov ebx, 1
 mov ecx, symbol 
 mov edx, 1
 int 0x80

 mov eax, [ind]          ;снова помещаем значение индекса в регистр eax
 dec eax                 ;уменьшаем его значение на 1
 mov [ind], eax          ;помещаем полученное значение обратно в переменную 
 jmp point3              ;переходим к метке point3

exit:                    ;завершаем программу

 mov eax, 1
 mov ebx, 0
 int 0x80