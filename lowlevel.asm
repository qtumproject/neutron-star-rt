CPU i686
BITS 32
SECTION .text
GLOBAL __start
GLOBAL __exit
GLOBAL __push_sccs
GLOBAL __pop_sccs
GLOBAL __peek_sccs
GLOBAL __exchange_sccs
GLOBAL __dup_sccs
GLOBAL __sccs_item_count
GLOBAL __sccs_memory_size
GLOBAL __sccs_memory_remaining
GLOBAL __sccs_item_limit_remaining
GLOBAL __gas_remaining
GLOBAL __exit_execution
GLOBAL __revert_execution
GLOBAL __execution_type
GLOBAL __system_call

EXTERN _init
EXTERN _neutron_main
EXTERN __init_neutron

[SECTION __start_text]
__start:
mov esp, 0x80010000 + 1024 * 7 ; init stack for Qtum stack space
call __init_neutron ;internal qtum runtime setup
mov eax, 0
call _neutron_main ;main function
int 0xFF ;exit_execution system call
hlt
[SECTION .text]

;Summary of interface:
; 
; Note: returning u64 values uses the EAX:EDX "mostly but not quite" standard cdcel convention
; Order of registers: EAX, ECX, EDX
;
; -- SCCS functions
; Interrupt 0x10: push_sccs (buffer, size)
; Interrupt 0x11: pop_sccs (buffer, max_size) -> actual_size: u32
; Interrupt 0x12: peek_sccs (buffer, max_size, index) -> actual_size: u32
; Interrupt 0x13: swap_sccs (index)
; Interrupt 0x14: dup_sccs()
; Interrupt 0x15: sccs_item_count() -> size
; Interrupt 0x16: sccs_memory_size() -> size
; Interrupt 0x17: sccs_memory_remaining() -> size
; Interrupt 0x18: sccs_item_limit_remaining() -> size
;
; -- CallSystem functions
; Interrupt 0x20: system_call(feature, function) -> error:u32
;
; -- Hypervisor functions
; Interrupt 0x80: alloc_memory TBD
;
; -- Context functions
; Interrupt 0x90: gas_used() -> u64
; Interrupt 0x91: self_address() -- result on stack as NeutronShortAddress
; Interrupt 0x92: origin() -- result on stack as NeutronShortAddress
; Interrupt 0x93: origin_long() -- result on stack as NeutronLongAddress
; Interrupt 0x94: sender() -- result on stack as NeutronShortAddress
; Interrupt 0x95: sender_long() -- result on stack as NeutronLongAddress
; Interrupt 0x96: value_sent() -> u64
; Interrupt 0x97: nest_level() -> u32
; Interrupt 0x98: gas_remaining() -> u64
; Interrupt 0x99: execution_type() -> u32
;
; -- System interrupts
; Interrupt 0xFE: revert_execution(status) -> noreturn
; Interrupt 0xFF: exit_execution(status) -> noreturn)

;int __push_sccs(void* buffer, size_t buffer_size)
__push_sccs:
mov eax, [esp + 4 + 0]
mov ecx, [esp + 4 + 4]
int 0x10
ret
;int __pop_sccs(void* buffer, size_t max_size)
__pop_sccs:
mov eax, [esp + 4 + 0]
mov ecx, [esp + 4 + 4]
int 0x11
ret

;int __peek_sccs(void* buffer, size_t buffer_size, unsigned int index)
__peek_sccs:
mov eax, [esp + 4 + 0]
mov ecx, [esp + 4 + 4]
mov edx, [esp + 4 + 8]
int 0x12
ret

;int __swap_sccs(unsigned int index)
__swap_sccs:
mov eax, [esp + 4 + 0]
int 0x13
ret

;int __dup_sccs()
__dup_sccs:
int 0x14
ret
;size_t __sccs_item_count()
__sccs_item_count:
int 0x15
ret
;size_t __sccs_memory_size()
__sccs_memory_size:
int 0x16
ret
;size_t __sccs_memory_remaining()
__sccs_memory_remaining:
int 0x17
ret
;size_t __sccs_item_limit_remaining()
__sccs_item_limit_remaining:
int 0x18
ret



;uint64_t __gas_remaining()
__gas_remaining:
int 0x98
ret

;void __exit_execution() -- no return
__exit_execution:
mov eax, [esp + 4 + 0]
int 0xFF
hlt ;should never reach here

;void __revert_execution() -- no return
__revert_execution:
mov eax, [esp + 4 + 0]
int 0xFE
hlt ;should never reach here

;unsigned int __execution_type()
__execution_type:
int 0x99
ret

;int __system_call(unsigned int feature_set, unsigned int function)
__system_call:
mov eax, [esp + 4 + 0]
mov ecx, [esp + 4 + 4]
int 0x20
ret


