[bits 32]
[extern main]
 

test_a20:
 pushad
 mov edi, 0x112345
 mov esi, 0x012345
 mov [esi], esi
 mov [edi], edi
 cmpsd
 popad
 jne long_mode 
 call enable_a20


long_mode:
 ; Check if CPUID is supported by attempting to flip the ID bit (bit 21) in
 ; the FLAGS register. If we can flip it, CPUID is available.
 
 ; Copy FLAGS in to EAX via stack
 pushfd
 pop eax
 
 ; Copy to ECX as well for comparing later on
 mov ecx, eax
 
 ; Flip the ID bit
 xor eax, 1 << 21
 
 ; Copy EAX to FLAGS via the stack
 push eax
 popfd
 
 ; Copy FLAGS back to EAX (with the flipped bit if CPUID is supported)
 pushfd
 pop eax
 
 ; Restore FLAGS from the old version stored in ECX (i.e. flipping the ID bit
 ; back if it was ever flipped).
 push ecx
 popfd
 
 ; Compare EAX and ECX. If they are equal then that means the bit wasn't
 ; flipped, and CPUID isn't supported.
 xor eax, ecx
 jz NoCPUID

 ;; Now check for CPUID
 mov eax, 0x80000000    ; Set the A-register to 0x80000000.
 cpuid                  ; CPU identification.
 cmp eax, 0x80000001    ; Compare the A-register with 0x80000001.
 jb NoLongMode         ; It is less, there is no long mode.
 mov eax, 0x80000001
 cpuid
 test edx, 1 << 29
 jz NoLongMode

done:
 call main
 jmp $

NoLongMode:
NoCPUID:
enable_a20:
 jmp $

