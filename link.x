ENTRY(__start)

EXTERN(__sheap)
EXTERN(__start)

MEMORY
{
    CODEMEM : ORIGIN = 0x10000, LENGTH = 63K
    CODEMEMAUX1 : ORIGIN = 0x20000, LENGTH = 63K
    CODEMEMAUX2 : ORIGIN = 0x30000, LENGTH = 63K
    CODEMEMAUX3 : ORIGIN = 0x40000, LENGTH = 63K
    CODEMEMAUX4 : ORIGIN = 0x50000, LENGTH = 63K
    CODEMEMAUX5 : ORIGIN = 0x60000, LENGTH = 63K
    CODEMEMAUX6 : ORIGIN = 0x70000, LENGTH = 63K
    CODEMEMAUX7 : ORIGIN = 0x80000, LENGTH = 63K
    DATAMEM : ORIGIN = 0x80020000, LENGTH = 63K
}
/* # Sections */
SECTIONS
{
  /* ### .text */
  .text :
  {
    *(__start_text);
    *(.text .text.*);
    *(.rodata .rodata.*);
  } > CODEMEM
  /* # aux code sections */
  .textaux1 :
  {
    *(.textaux1 .textaux1.*);
  } > CODEMEMAUX1
  .textaux2 :
  {
    *(.textaux2 .textaux2.*);
  } > CODEMEMAUX2
  .textaux3 :
  {
    *(.textaux3 .textaux3.*);
  } > CODEMEMAUX3
  .textaux4 :
  {
    *(.textaux4 .textaux4.*);
  } > CODEMEMAUX4
  .textaux5 :
  {
    *(.textaux5 .textaux5.*);
  } > CODEMEMAUX5
  .textaux6 :
  {
    *(.textaux6 .textaux6.*);
  } > CODEMEMAUX6
  .textaux7 :
  {
    *(.textaux7 .textaux7.*);
  } > CODEMEMAUX7


  /* ## Sections in RAM */
  /* ### .data */
  .data : ALIGN(4)
  {
    . = ALIGN(4);
    __sdata = .;
    *(.data .data.*);
    . = ALIGN(4); /* 4-byte align the end (VMA) of this section */
    __edata = .;
  } > DATAMEM AT > CODEMEM

  /* LMA of .data */
  __sidata = LOADADDR(.data);

  /* ### .bss */
  .bss : ALIGN(4)
  {
    . = ALIGN(4);
    __sbss = .;
    *(.bss .bss.*);
    . = ALIGN(4); /* 4-byte align the end (VMA) of this section */
    __ebss = .;
  } > DATAMEM

  /* ### .uninit */
  .uninit (NOLOAD) : ALIGN(4)
  {
    . = ALIGN(4);
    *(.uninit .uninit.*);
    . = ALIGN(4);
  } > DATAMEM

  /* Place the heap right after `.uninit` */
  . = ALIGN(4);
  __sheap = .;

  /* ## .got */
  /* Dynamic relocations are unsupported. This section is only used to detect relocatable code in
     the input files and raise an error if relocatable code is found */
  .got  :
  {
    KEEP(*(.got .got.*));
  }

  /* ## Discarded sections */
  /DISCARD/ :
  {
    /* Unused exception related info that only wastes space */
    *(.ARM.exidx);
    *(.ARM.exidx.*);
    *(.ARM.extab.*);
    *(.debug*);
    *(.comment*);
    *(.eh_frame*);
    
  }
}

ASSERT(SIZEOF(.got) == 0, "
ERROR(neutron): .got section detected in the input object files
Dynamic relocations are not supported. If you are linking to C code compiled using
the 'cc' crate then modify your build script to compile the C code _without_
the -fPIC flag. See the documentation of the `cc::Build.pic` method for details.");

