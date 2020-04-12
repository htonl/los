[bits 32]
; Define some constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string pointed to by EDX

print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY  ; Set edx to the start of vid memory

print_string_pm_loop:
  mov al, [ebx]          ; Store the char at EBX in AL
  mov ah, WHITE_ON_BLACK ; Store the attributes in ah
  
  cmp al, 0 ; if al is zero, that is eos
  je done

  mov [edx], ax
  
  add ebx, 1 ; inc ebx to next char in string
  add edx, 2 ; move to next character cell in vid mem. cell is 2 bytes

  jmp print_string_pm_loop

print_string_pm_done:
  popa
  ret

