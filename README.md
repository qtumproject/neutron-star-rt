# Neutron-star-rt

This is the minimal runtime and low level routines required to use the Qtum Neutron x86 platform. This includes using proper linking setup and several assembly routines for system calls and initialization. 

To compile:

    ./assemble.sh # requires yasm to be installed
    xargo build --target i486-qtum


The following functions should be defined by users of this crate:

    #[no_mangle]
    pub extern "C" fn __init_qtum() {}

This is used internally by the neutron-star crate and is called before the main function is called. 

    fn on_call() -> u32;
    fn on_create() -> u32;

These two functions must be defined by the using crate and are executed when the contract is called or initially created, respectively. 

# Caveats

Static initializers probably do not work.

This requires a nightly build currently to use because of the custom target needed for the `core` crate.

