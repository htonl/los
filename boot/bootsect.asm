; A boot sector that enters 32 - bit protected mode.
[ org 0x7c00 ]
KERNEL_OFFSET equ 0x1000  ; This is the memory offset to kernel
  mov [BOOT_DRIVE], dl
  mov bp , 0x9000 ; Set the stack.
  mov sp , bp
  mov bx , MSG_REAL_MODE
  call print_string
  call print_nl
  call load_kernel
  mov bx, MSG_FINISHED_LOAD_KERN
  call print_string
  call print_nl
  call switch_to_pm ; Note that we never return from here.

  jmp $

%include "boot/print.asm"
%include "boot/print_hex.asm"
%include "boot/disk_load.asm"
%include "boot/load_gdt.asm"
%include "boot/print_string_pm.asm"
%include "boot/switch_to_pm.asm"

[ bits 16 ]
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string
  call print_nl
  mov bx, KERNEL_OFFSET
  mov dh, 2
  mov dl, [BOOT_DRIVE]
  call disk_load
  ret

[ bits 32]

; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM :
  mov ebx , MSG_PROT_MODE

  call print_string_pm ; Use our 32 - bit print routine.
  call KERNEL_OFFSET

  jmp $ ; Hang.

; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db " Started in 16 - bit Real Mode " , 0
MSG_PROT_MODE db " Successfully landed in 32 - bit Protected Mode " , 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0
MSG_FINISHED_LOAD_KERN db "Finished lodaing kernel.", 0

; Bootsector padding
times 510 -( $ - $$ ) db 0
dw 0xaa55
