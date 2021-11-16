.model small
.stack 256
.data
a dw ?
b dw ?
c dw ?
d dw ?
.code

main:
mov ax, @data
mov ds, ax
call readNum
mov a, bx
call readNum
mov b, bx
call readNum
mov c, bx
call readNum
mov d, bx
; check:  if (a > b)
mov ax, a
mul c
mov bx, b
sub bx, d
cmp ax, bx
je printFirst
mov ax, a
mov bx, d
cmp ax, bx
jg printFirst

; if all first condition is false:
fistAllConditionIsFalse:
mov ax, d
add ax, a
mov bx, b
sub bx, c
cmp bx, ax
jg printSecond

; print (2 * c + 3 * d - 5)
mov ax, 3
mul d
mov bx, ax
mov ax, 2
mul c
sub ax, 5
add ax, bx
jmp print


; print (a + b * (c - d))
printFirst:
mov ax, c
sub ax, d
mul b
add ax, a
jmp print

; print (a * a - b + c)
printSecond:
mov ax, a
cmp ax, b
jg fistAllConditionIsFalse
mov ax, a
mul a
sub ax, b
add ax, c
jmp print


; read and print nums
print:
call printNum

exit:
mov ah, 04Ch
mov al, 0
int 21h

readNum:
; тк bx используется, то обнуляем
mov bx, 0
; получение числа
mov ah, 01h
int 21h
; сравнение со знаком минуса
cmp al, 2dh
je negativeNum
; если либо цифра больше 0, либо конец строки
call analyze
ret

negativeNum:
; меняем знак с положительного на отрицательный у введенного числа
call readPositiveNum
not bx 
inc bx
ret

readPositiveNum:
; чтение положительного числа
mov ah, 01h
int 21h

analyze:
; проверки на \r и \n
cmp al, 0dh
je endl
cmp al, 10
je endl
; получение числа
sub al, 48
; обнуление ah чтобы там ниче не было
mov ah, 0
push ax
; для получения числа (т.к. по символам принимаем) 
; то нужно умножать
; на 10 каждый раз, ибо 10тичная система
mov ax, 10
mul bx
mov bx, ax
pop ax
; в bx хранится конечное число, к которому 
; мы рекурсией прибавляем ax (новый введенный символ)
add bx, ax
call readPositiveNum

endl:
ret

printNum:
cmp ax, 0
jz printZero
jnl printPositiveNum
mov dl, '-'
push ax
mov ah, 02h
int 21h
pop ax
not ax 
inc ax

printPositiveNum:
cmp ax, 0
jz zero
; перевод обратно в аски
mov dx, 0
mov bx, 10
div bx    
add dl, 48
push dx
call printPositiveNum
; вывод в консоль dx (по символу рекурсией)
pop dx
mov ah, 02h
int 21h

zero:
ret

printZero:
; выводим ноль ('0')
mov dl, 30h
; говорим о том, что хотим вывести
mov ah, 02h
; dos прирывание
int 21h
ret

end main