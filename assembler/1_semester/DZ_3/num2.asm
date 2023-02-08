section .bss
 fd1 resb 4    ;выделяем 4 байта для файлового дескриптора первого файла
 fd2 resb 4    ;выделяем 4 байта для файлового дескриптора второго файла
 fd3 resb 4    ;выделяем 4 байта для файлового дескриптора третьего файла
 buf resb 1    ;выделяем 1 байт для buf
 fname1 resb 4    ;выделяем 4 байта для переменной fname1, которая будет содержать имя первого файла
 fname2 resb 4    ;выделяем 4 байта для переменной fname2, которая будет содержать имя второго файла

section .text:
global _start
_start:
 pop ebx    ;передаём имена трех файлов при запуске программы
 pop ebx    
 pop ebx              ;после третьей операции pop регистр ebx указывает на строку с именем первого файла
 mov [fname1], ebx    ;записываем имя первого файла в переменную fname1   
 pop ebx              ;теперь регистр ebx указывает на строку с именем второго файла
 mov [fname2], ebx    ;записываем имя второго файла в переменную fname1 
 pop ebx              ;после третьей операции pop регистр ebx указывает на строку с именем третьего файла

 mov eax, 8           ;создаём новый файл, в который будет записано содержимое первого и второго файлов, задаём системный вызов sys_creat, в регистре ebx уже находится имя нужного нам файла
 mov ecx, 420         ;задаём права доступа к новому файлу
 int 0x80
 mov [fd3], eax       ;после создания файла помещаем файловый дескриптор в переменную fd3

 mov ebx, [fname1]    ;помещаем в регистр ebx имя первого файла
 mov eax, 5           ;задаём системный вызов sys_open
 mov ecx, 0           ;задаём режим открытия файла, в данном случае открываем файл только для чтения
 mov edx, 0           
 int 0x80
 mov [fd1], eax       ;после открытия файла помещаем файловый дескриптор в переменную fd1
 
 mov ebx, [fname2]    ;проделываем те же операции со вторым файлом, из которого требуется считать данные
 mov eax, 5
 mov ecx, 0
 mov edx, 0
 int 0x80
 mov [fd2], eax
 
point:               ;создаём метку point
 mov eax, 3          ;теперь считываем один байт из первого файла, для этого задаём системный вызов sys_read
 mov ebx, [fd1]      ;передаём значение файлового дескриптора первого файла
 mov ecx, buf        ;считываем в переменную buf
 mov edx, 1          ;считываем 1 байт
 int 0x80
 
 cmp eax, 1    ;этот системный вызов по результату выполнения возвращает число действительно считанных байт
 jne point2    ;это число хранится в eax, поэтому если значение eax не равно единице, то если достигнут конец файла, то
               ;перемещаемся к метке point2
 mov eax, 4        ;задаём системный вызов sys_write
 mov ebx, [fd3]    ;передаём значение файлового дескриптора третьего файла
 mov ecx, buf      ;записываем в третий файл значение переменной buf
 mov edx, 1
 int 0x80 
 jmp point         ;перемещаемся к метке point

point2:          ;как только достигнут конец первого файла, мы перемещаемся к метке point2 
 mov eax, 6      ;закрываем первый файл
 mov ebx, [fd1]
 int 0x80

 mov eax, 3       ;теперь считываем один байт из второго файла, для этого задаём системный вызов sys_read
 mov ebx, [fd2]   ;передаём значение файлового дескриптора второго файла
 mov ecx, buf     ;считываем в переменную buf 1 байт
 mov edx, 1
 int 0x80
 
 cmp eax, 1    ;этот системный вызов по результату выполнения возвращает число действительно считанных байт
 jne point3    ;это число хранится в eax, поэтому если значение eax не равно единице, то если достигнут конец файла, то
               ;перемещаемся к метке point3
 mov eax, 4        ;задаём системный вызов sys_write
 mov ebx, [fd3]    ;передаём значение файлового дескриптора третьего файла
 mov ecx, buf      ;записываем в третий файл значение переменной buf
 mov edx, 1
 int 0x80
 jmp point2        ;перемещаемся обратно к метке point2

point3:           ;как только достигнут конец первого файла, мы перемещаемся к метке point3
 mov eax, 6       ;закрываем второй файл
 mov ebx, [fd2]
 int 0x80

 mov eax, 6       ;закрываем третий файл
 mov ebx, [fd3]
 int 0x80

 mov eax, 1       ;завершаем выполнение программы
 mov ebx, 0 
 int 0x80
 