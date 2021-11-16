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

fistFalse:
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
jg fistFalse
mov ax, a
mul a
sub ax, b
add ax, c
jmp print

print:
call printNum

exit:
mov ah, 04Ch
mov al, 0
int 21h

readNum:
mov bx, 0
mov ah, 01h
int 21h
cmp al, 2dh
je negativeNum
call analyze
ret

negativeNum:
call readPositiveNum
not bx 
inc bx
ret

readPositiveNum:
mov ah, 01h
int 21h

analyze:
cmp al, 0dh
je endl
cmp al, 10
je endl
sub al, 48
mov ah, 0
push ax
mov ax, 10
mul bx
mov bx, ax
pop ax
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
mov dx, 0
mov bx, 10
div bx    
add dl, 48
push dx
call printPositiveNum
pop dx
mov ah, 02h
int 21h

zero:
ret

printZero:
mov dl, 30h
mov ah, 02h
int 21h
ret

end main