;
; Print the null terminated string pointed to by bx
;

print_string:
    pusha
    mov ah, 0x0e
    print_loop:
        mov al, [bx]
        cmp al, 0
        jz done
        int 0x10
        add bx, 0x01
        jmp print_loop
    done:
        popa
        ret

print_nl:
    pusha
    mov ah, 0x0e
    mov al, 0x0a
    int 0x10
    mov al, 0x0d
    int 0x10
    popa
    ret 
