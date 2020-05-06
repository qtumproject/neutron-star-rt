#!/bin/sh

yasm -Werror lowlevel.asm -o bin/lowlevel.o -f elf32
