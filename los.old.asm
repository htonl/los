;
; Simple boot sector program
;

;
; Set the stack to 0x8000
;
[org 0x7c00]
mov bp, 0x8000
mov sp, bp

mov bx, 0x9000 ; es:bx = 0x0000:0x9000 = 0x9000
mov dh, 2      ; read 2 sectors

call disk_load

mov dx, [0x9000]
call print_hex
call print_nl

mov dx, [0x9000 + 512]
call print_hex
call print_nl

; Prints the value of DX as hex.

mov bx, HELLO
call print_string
call print_nl

jmp $             ; Hang once we're done

%include "print.asm"
%include "print_hex.asm"
%include "disk_load.asm"
%include "load_gdt.asm"
%include "print_32bit.asm

HEX_OUT: db '0x0000', 0

HELLO: db 'hello', 0

; Padding and magic number

times 510-($-$$) db 0
dw 0xaa55

; boot sector = sec 1 of cyl 0 of head 0 of hdd 0 
; from now on = sector 2 ...
times 256 dw 0xdada ; sector 2 = 512 bytes
times 256 dw 0xface ; sector 3 = 512 bytes
