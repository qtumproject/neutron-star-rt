CPU i686
BITS 32
SECTION .text
GLOBAL __start
GLOBAL __exit
GLOBAL __qtum_syscall
GLOBAL __qtum_syscall_short

EXTERN _init
EXTERN _qtum_main
EXTERN __init_qtum

[SECTION __start_text]
__start:
mov esp, 0x80010000 + 1024 * 7 ; init stack for Qtum stack space
call __init_qtum ;internal qtum runtime setup
mov eax, 0
call _qtum_main ;main function

exit:
; eax is return code
int 0xF0 ; VM escape API for ending execution
hlt ; should never reach this

[SECTION .text]

; long __qtum_syscall(long number, long p1, long p2, long p3, long p4, long p5, long p6)
__qtum_syscall:
  push ebp
  push edi
  push esi
  push ebx
  mov eax, [esp + 20]
  mov ebx, [esp + 20 + 4]
  mov ecx, [esp + 20 + 8]
  mov edx, [esp + 20 + 12]
  mov esi, [esp + 20 + 16]
  mov edi, [esp + 20 + 20]
  mov ebp, [esp + 20 + 24]
  int 0x40
  pop ebx
  pop esi
  pop edi
  pop ebp
  ret

; long __qtum_syscall_short(long number, long p1, long p2, long p3)
__qtum_syscall_short:
  push ebx
  mov eax, [esp + 8]
  mov ebx, [esp + 8 + 4]
  mov ecx, [esp + 8 + 8]
  mov edx, [esp + 8 + 12]
  int 0x40
  pop ebx
  ret

; void __exit(long exit_code)
__exit:
; eax is return code
mov eax, [esp + 4]
int 0xF0 ; VM escape API for ending execution
hlt ; should never reach this

