# cornercut-compile

Template for single file C/C++/Objective-C/Objective-C/Fortran source distribution

## Purpose of this script

The helper to distribute the small program with source file written in C/C++/Objective-C/Objective-C/(g)fortran. It is also useful to transport the small program with source file to other environment.

## Usage

1. Copy the shell script template (`cornercut-compile_header.sh` or  `cornercut-compile_header-short.sh`) with the project name with the appropriate filename extension (suffix). The extension should be `.(language-default-extension).sh`. Refer [GCC manual](https://gcc.gnu.org/onlinedocs/gcc/Overall-Options.html) for the language default extensions. Difference between `cornercut-compile_header.sh` and `cornercut-compile_header-short.sh` is just if it includes the verbose comments or not.

```sh
% cp -ai 'cornercut-compile_header.sh'       'example.cc.sh'
```
or 
```sh
% cp -ai 'cornercut-compile_header-short.sh' 'example.cc.sh'
```

2. (optional) Adjust magic comments (2nd line of the file) in the copied file (`example.cc.sh`) for text editor (especially for Emacs major mode selection).

3. Adjust the default shell variables, if needed. (Specify the required library file, and so on.)

4. Add the actual source code at the end of the copied file (`example.cc.sh`)

5. Run as the shell scripts. Command-line arguments will be passed to the compiled program as it is.

```sh
% ./example.cc.sh [arg1] [arg2] ...
```

If you want to doing the compile code only, give non-zero value to the environmental variables: `keep_bin`. If the environmental variable `autorun` is zero, the compiled binary will not be invoked.
  
```sh
% env autorun=0 keep_bin=1 ./example.cc.sh
% ls -l example
```

If you want to obtain the pure source doing the compile code only, give non-zero value to the environmental variables: `keep_src`.
  
```sh
% env autorun=0 keep_src=1 ./example.cc.sh
% ls -l example.cc
```

When the file with same filename as the compiled binary (`example` for the example above, or `a.out` in some case.), this script will be aborted to avoid the overriding existing file. If you do not care the override, give non-zero value to the environmental variables: `force_build`.

```sh
% ls -l example
% env force_build=1 ./example.cc.sh
```

These variables can be hard-coded at the beginning of the scripts.(`example.cc.sh`) 

## Examples

- Sample codes/scripts exists under `example` directory. This example file includes source codes, which are written in C, C++, Objective-C, Objective-C++ and fortran and selected by compiler pre-processor, to say "Hello world!" with listing the command-line arguments. Language selection will be done based on the suffix of the filename.

```
% ls -l example/
-rwxr-xr-x ...... cornercut-compile-example.sh
lrwxr-xr-x ...... cornercut-compile-example.c.sh  -> cornercut-compile-example.sh
lrwxr-xr-x ...... cornercut-compile-example.m.sh  -> cornercut-compile-example.sh
lrwxr-xr-x ...... cornercut-compile-example.cc.sh -> cornercut-compile-example.sh
lrwxr-xr-x ...... cornercut-compile-example.mm.sh -> cornercut-compile-example.sh
lrwxr-xr-x ...... cornercut-compile-example.F.sh  -> cornercut-compile-example.sh
```

- `*.c.sh` will be compiled as source code in C , and then run with arguments.

```c:cornercut-compile-example.c-->cornercut-compile-example
% ./example/cornercut-compile-example.c.sh arg1 arg2 arg3 
Hello, world! (C) 
0  ./example/cornercut-compile-example
1  arg1
2  arg2
3  arg3
```

- `*.m.sh` will be compiled as source code in Objective-C, and then run with arguments.

```objective-c:cornercut-compile-example.m-->cornercut-compile-example
% ./example/cornercut-compile-example.m.sh arg1 arg2 arg3
Hello, World! (Objective-C)
0  /.../.../example/cornercut-compile-example
1  arg1
2  arg2
3  arg3
```

- `*.cc.sh` will be compiled as source code in C++ , and then run with arguments.

```c++:cornercut-compile-example.cc-->cornercut-compile-example
% ./example/cornercut-compile-example.cc.sh arg1 arg2 arg3
Hello, world! (C++)
0 ./example/cornercut-compile-example
1 arg1
2 arg2
3 arg3
```

- `*.mm.sh` will be compiled as source code in Objective-C++, and then run with arguments.

```objective-c++:cornercut-compile-example.mm-->cornercut-compile-example
% ./example/cornercut-compile-example.mm.sh arg1 arg2 arg3
Hello, World! (Objective-C++)
0 /.../.../example/cornercut-compile-example
1 arg1
2 arg2
3 arg3
```

- `*.F.sh` will be compiled as source code in Fortran , and then run with arguments.

```Fortran:cornercut-compile-example.F-->cornercut-compile-example
% ./example/cornercut-compile-example.F.sh arg1 arg2 arg3
 Hello, world! (Fortran)
 0 ./example/cornercut-compile-example
 1 arg1
 2 arg2
 3 arg3
```

- When the programming language can not be identified from suffix, it will be compiled as source code in c++, and then run with arguments.

```c++:(default)-->a.out
% ./example/cornercut-compile-example.sh arg1 arg2 arg3
[Warning: cornercut-compile-example.sh] Can not identify language. C++ is assumed
Hello, world! (C++)
0 ./example/a.out
1 arg1
2 arg2
3 arg3
```

## Author
  Nanigashi Uji (53845049+nanigashi-uji@users.noreply.github.com)
