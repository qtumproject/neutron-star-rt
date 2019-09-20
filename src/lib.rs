#![feature(lang_items, start)]
#![no_std]

extern "C"{
    //long __qtum_syscall(long number, long p1, long p2, long p3, long p4, long p5, long p6)
    pub fn __qtum_syscall(num: u32, p1: u32, p2: u32, p3: u32, p4: u32, p5: u32, p6: u32) -> u32;
    pub fn __qtum_syscall_short(num: u32, p1: u32, p2: u32, p3: u32) -> u32;
    pub fn __exit(exit_code: u32) -> !;
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
pub extern "C" fn _qtum_main() -> u32 {
    main();
    unsafe{
        let is_create_address: usize = 0x70000000 + 8;
        let is_create = is_create_address as *const u32;
        return if *is_create > 0{
            on_create()
        }else{
            on_call()
        }
    }
}

#[panic_handler]
pub fn _qtum_panic_handler(_info: &core::panic::PanicInfo) -> ! {
    unsafe{
        //return fault + error + revert
        __exit(8 + 1 + 2);
    }
}
