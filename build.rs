use std::env;
use std::fs::File;
use std::io::Write;
use std::path::PathBuf;
extern crate cc;

fn main() {
    // Put the linker script somewhere the linker can find it
    let out = &PathBuf::from(env::var_os("OUT_DIR").unwrap());
    File::create(out.join("link.x"))
        .unwrap()
        .write_all(include_bytes!("link.x"))
        .unwrap();
    println!("cargo:rustc-link-search={}", out.display());



    // Only re-run the build script when memory.x is changed,
    // instead of when any part of the source code changes.
    println!("cargo:rerun-if-changed=link.x");

    cc::Build::new()
        .object("bin/lowlevel.o")
        .compile("qtum_lowlevel");
    println!("cargo:rerun-if-changed=bin/lowlevel.o");
}