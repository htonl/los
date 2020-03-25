;
; Simple boot sector program
;

;
; Set the stack to 0x8000
;
[org 0x7c00]

; Prints the value of DX as hex.
  mov dx, 0x1fb7    ; Set the value we want to print to dx
  call print_hex    ; Print the hex value
  jmp $             ; Hang once we're done

%include "print.asm"
%include "print_hex.asm"

HEX_OUT: db '0x0000', 0

; Padding and magic number

  times 510-($-$$) db 0
  dw 0xaa55
