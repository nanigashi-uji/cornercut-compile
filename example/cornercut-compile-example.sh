#!/bin/bash
# /* -*- mode: C++ ; coding: utf-8 ; truncate-lines: t -*- */
# /* <-- change mode string manually:  C | C++ | Objc | Fortran | f90 | Shell-script */
# /*  
#     cornercut-compile: Nanigashi Uji (53845049+nanigashi-uji@users.noreply.github.com)
#
this="${0}"; this_bn="$(basename "${this}")"
#
# Variables for compiler options
#  (usual Environmental variables also work: CC, CFLAGS, CPPFLAGS, CXX, CXXFLAGS, FC, FFLAGS, LDFLAGS, LDLIBS)
#
# Compilier options: Adding include path, macro options, compiler warning options and so on.
cmpflgs_add='-I'"$(dirname "${this}")"
#
# Linker options: Adding library path, required library file and so on.
ldflgs_add='-Wl,-rpath,'"$(dirname "${this}")"' -Wl,-L,'"$(dirname "${this}")"
ldlibs_add=
# Example: ldlibs_add='-lm'
#
# Variables to change this script behavior: Change it below or Give it as envriomental variable, if necessary
#  autorun=1 keep_bin=0 keep_src=0 force_build=0 (default) : Compile code for each run and clean up. Stop compiling if the binary is already exists.
#  autorun=0 keep_bin=1                                    : Compile code only. do not execute it.
#  autorun=0 keep_src=1                                    : Check code compile and generate pure source code if succeeded.
#
# autorun : 0 = compile only (useful to use with keep_bin=1 and/or keep_src=1)
#           1 = execute the program with given commandline arguments after compile succeeded (default)
#autorun=1
#
# keep_bin : 0 = remove the executable binary file (i.e. compiler output)  (default)
#            1 = keep the executable binary file (i.e. compiler output) 
#keep_bin=0
#
# keep_src : 0 = Do not generate the pure source code file (i.e. compiler input) (default)
#            1 = Generate the pure source code file (i.e. compiler input) 
#keep_src=0
#
# force_rebuild : 0 = Do not override the executable binary file. (If it already exists, this script will be aborted.) (Default.)
#                 1 = Do not check if the executable binary is already exists. (If it already exists, it will be overriden.)
#force_rebuild=0
#
# Default compiler determination
which "clang"   1>/dev/null 2>&1 && dfltcc="clang"    || dfltcc="gcc"
which "clang++" 1>/dev/null 2>&1 && dfltcxx="clang++" || dfltcxx="g++"
dfltfc="gfortran"
#
[ "${this_bn}" != "${this_bn%.*.*}" ] && exectbl="${this_bn%.*.*}" ; exectbl="$(dirname "${this}")/${exectbl:-a.out}"
[ "${this_bn}" != "${this_bn%.*}"   ] && src="${this_bn%.*}"   ; src="$(dirname "${this}")/${src:-${this_bn}.cxx}"
_extglob="$(shopt -p extglob)"; shopt -s extglob
case "${this}" in
    *.c.sh)                          cmplr="${CC:-${dfltcc:-cc}}"       ; cmplr_flg="${CFLAGS}"   ; cpp_flg="${CPPFLAGS}"    ; lang="c" ;;
    *.i.sh)                          cmplr="${CC:-${dfltcc:-cc}}"       ; cmplr_flg="${CFLAGS}"   ; cpp_flg="-fpreprocessed" ; lang="c" ;;
    *.m.sh)                          cmplr="${CC:-${dfltcc:-cc}}"       ; cmplr_flg="${CFLAGS}"   ; cpp_flg="${CPPFLAGS}"    ; lang="objective-c"   ; ldlibs_add="-framework Foundation ${ldlibs_add}" ;;
    *.mi.sh)                         cmplr="${CC:-${dfltcc:-cc}}"       ; cmplr_flg="${CFLAGS}"   ; cpp_flg="-fpreprocessed" ; lang="objective-c"   ; ldlibs_add="-framework Foundation ${ldlibs_add}" ;;
    *.@(mm|M).sh)                    cmplr="${CXX:-${dfltcxx:-c++}}"    ; cmplr_flg="${CXXFLAGS}" ; cpp_flg="${CPPFLAGS}"    ; lang="objective-c++" ; ldlibs_add="-framework Foundation ${ldlibs_add}" ;;
    *.mii.sh)                        cmplr="${CXX:-${dfltcxx:-c++}}"    ; cmplr_flg="${CXXFLAGS}" ; cpp_flg="-fpreprocessed" ; lang="objective-c++" ; ldlibs_add="-framework Foundation ${ldlibs_add}" ;;
    *.ii.sh)                         cmplr="${CXX:-${dfltcxx:-c++}}"    ; cmplr_flg="${CXXFLAGS}" ; cpp_flg="-fpreprocessed" ; lang="c++" ;;
    *.@(cc|cp|cxx|cpp|CPP|c++|C).sh) cmplr="${CXX:-${dfltcxx:-c++}}"    ; cmplr_flg="${CXXFLAGS}" ; cpp_flg="${CPPFLAGS}"    ; lang="c++" ;;
    *.@(f|for|ftn).sh)               cmplr="${FC:-${dfltfc:-gfortran}}" ; cmplr_flg="${FFLAGS}"   ; cpp_flg="-fpreprocessed" ; lang="f77"           ldlibs_add="-lgfortran ${ldlibs_add}";;
    *.@(F|FOR|fpp|FPP|FTN).sh)       cmplr="${FC:-${dfltfc:-gfortran}}" ; cmplr_flg="${FFLAGS}"   ; cpp_flg="${CPPFLAGS}"    ; lang="f77-cpp-input" ldlibs_add="-lgfortran ${ldlibs_add}";;
    *.@(f90|f95|f03|f08).sh)         cmplr="${FC:-${dfltfc:-gfortran}}" ; cmplr_flg="${FFLAGS}"   ; cpp_flg="-fpreprocessed" ; lang="f95"           ldlibs_add="-lgfortran ${ldlibs_add}";;
    *.@(F90|F95|F03|F08).sh)         cmplr="${FC:-${dfltfc:-gfortran}}" ; cmplr_flg="${FFLAGS}"   ; cpp_flg="${CPPFLAGS}"    ; lang="f95-cpp-input" ldlibs_add="-lgfortran ${ldlibs_add}";;
    *)                               cmplr="${CXX:-${dfltcxx:-c++}}"    ; cmplr_flg="${CXXFLAGS}" ; cpp_flg="${CPPFLAGS}"    ; lang="c++" ; echo "[Warning: ${this_bn}] Can not identify language. C++ is assumed" 1>&2 ;;
esac #
if [ -e "${exectbl}" -a ${force_rebuild:-0} -eq 0 ]; then
    exec echo "[Error: ${this_bn} ] ${exectbl} is already exist. (Compile is aborted.)" 1>&2
fi
#echo "${cmplr}" -x "${lang}" ${cmplr_flg} ${cpp_flg} ${cmpflgs_add} -o "${exectbl}" ${CCFLAGS} - ${LDFLAGS} ${ldflgs_add} ${LDLIBS} ${ldlibs_add} 
sedcmd='/^#line 0 ____FILE____/,$ { s/^(#line +0 +)____FILE____/\1"'"${this_bn%.*}"'"/ ; p ; }'
${SED:-sed} -nE -e "${sedcmd}" "${this}" |
  "${cmplr}" -x "${lang}" ${cmplr_flg} ${cpp_flg} ${cmpflgs_add} -o "${exectbl}" ${CCFLAGS} - ${LDFLAGS} ${ldflgs_add} ${LDLIBS} ${ldlibs_add} \
  &&  { if [ ${autorun:-1} -ne 0  ] ; then    "${exectbl}" "${@}"                               ; fi ; \
        if [ ${keep_bin:-0} -eq 0 ] ; then rm "${exectbl}"                                      ; fi ; \
        if [ ${keep_src:-0} -ne 0 ] ; then ${SED:-sed} -nE -e "${sedcmd}" "${this}" 1> "${src}" ; fi ; }
exit
# The source code will be implemented the after the line : '^#line 0 ...'
# */
#line 0 ____FILE____

#if defined(__cplusplus) && (__cplusplus != 0)
#if defined(__OBJC__) && (__OBJC__ != 0)

/* Objective-C++ */
#import <Foundation/Foundation.h>
#include <iostream>
int main(){
  NSString *buf = @"Hello, World! (Objective-C++)";
  NSArray *args = [[NSProcessInfo processInfo] arguments];
  std::cout << [buf UTF8String] << std::endl;
  for (NSInteger i=0;i<[args count];++i){
    NSString *argv = [args objectAtIndex:i];
    std::cout << i << " " << [argv UTF8String] << std::endl;
  }
  return 0;
}

#else /* __OBJC__ */

/* C++ */
#include <iostream>
int main(int argc, char* argv[]) {
  std::cout << "Hello, world! (C++)" << std::endl;
  for (int i=0;i<argc;++i){
    std::cout << i << " " << argv[i] << std::endl;
  }
  return 0;
}

#endif /* __OBJC__ */
#elif defined(__STDC__) && (__STDC__ != 0) /* __cplusplus */
#if defined(__OBJC__) && (__OBJC__ != 0)

/* Objective-C */
#import <Foundation/Foundation.h>
#include <stdio.h>
int main(){
  NSInteger i;
  NSString *argv;
  NSString *buf = @"Hello, World! (Objective-C)";
  NSArray *args = [[NSProcessInfo processInfo] arguments];


  printf ("%s\n", [buf UTF8String]);
  for (i=0;i<[args count];++i){
    argv = [args objectAtIndex:i];
    printf("%-2ld %s\n", i, [argv UTF8String]);
  }
  return 0;
}

#else /* __OBJC__ */

/* C */
#include <stdio.h>
int main(int argc, char* argv[]){
  printf ("Hello, world! (C) \n");
  for (int i=0;i<argc;++i){
    printf("%-2d %s\n", i, argv[i]);
  }
  return 0;
}
#endif /* __OBJC__ */
#else /* __STDC__ */ /* __cplusplus */

c /*  Fortran */
      PROGRAM TRIAL
      IMPLICIT NONE
      INTEGER i
      CHARACTER*70 sargv
      
      WRITE (*,*) 'Hello, world! (Fortran)'
      DO i=0, iargc()
         CALL getarg(i, sargv)
         WRITE (*,'(i2,1X,A)') i,sargv
      ENDDO

      END PROGRAM

#endif /* __STDC__ */ /* __cplusplus */
