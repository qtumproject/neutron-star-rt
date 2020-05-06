#![feature(lang_items, start)]
#![no_std]

extern "C"{
    pub fn __exit_execution(exit_code: u32) -> !;
    pub fn __revert_execution(exit_code: u32) -> !;
    //note, even functions that don't return a value, should always return a u32 to account for invalidation of EAX
    pub fn __push_sccs(buffer: *const u8, size: usize) -> u32;
    pub fn __pop_sccs(buffer: *mut u8, max_size: usize) -> usize;
    pub fn __peek_sccs(buffer: *mut u8, max_size: usize, index: u32) -> usize;
    pub fn __swap_sccs(index: u32) -> u32;
    pub fn __dup_sccs() -> u32;
    pub fn __sccs_item_count() -> u32;
    pub fn __sccs_memory_size() -> usize;
    pub fn __sccs_memory_remaining() -> usize;
    pub fn __sccs_item_limit_remaining() -> u32;

    pub fn __system_call(feature: u32, function: u32) -> u32;

    pub fn __gas_limit() -> u64;
    pub fn __gas_remaining() -> u64;
    pub fn __execution_type() -> u32;
}

//should be provided by final bin crate that includes this crate
extern "Rust"{
    fn on_call() -> u32;
    fn on_create() -> u32;
}
pub fn main(){}

//note that __init_qtum() is called before _qtum_main
#[start]
#[no_mangle]
pub extern "C" fn _neutron_main() -> u32 {
    main();
    unsafe{
        let is_create = __execution_type() == 1;
        return if is_create {
            on_create()
        }else{
            on_call()
        }
    }
}
