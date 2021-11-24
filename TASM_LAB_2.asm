.model small
.stack 256
.code

main:
call readNum
mov cx, bx
cmp bx, 0
ja cycle

cycle:
mov ax, cx
mul ax
cmp ax, bx
jb print
dec cx
jmp cycle

print:
mov ax, cx
call printNum

exit:
mov ah, 04Ch
mov al, 0
int 21h



readNum:
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
call readNum

endl:
ret

printNum:
cmp ax, 0
jz printZero
jnl printNumber

printNumber:
cmp ax, 0
jz zero
mov dx, 0
mov bx, 10
div bx    
add dl, 48
push dx
call printNumber
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