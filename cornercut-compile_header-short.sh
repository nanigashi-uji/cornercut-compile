#!/bin/bash
# /* -*- mode: C++ ; coding: utf-8 ; truncate-lines: t -*- */
# /*  cornercut-compile: Nanigashi Uji (53845049+nanigashi-uji@users.noreply.github.com)
this="${0}"; this_bn="$(basename "${this}")"
cmpflgs_add='-I'"$(dirname "${this}")"
ldflgs_add='-Wl,-rpath,'"$(dirname "${this}")"' -Wl,-L,'"$(dirname "${this}")"
ldlibs_add=
#autorun=1
#keep_bin=0
#keep_src=0
#force_rebuild=0
which "clang"   1>/dev/null 2>&1 && dfltcc="clang"    || dfltcc="gcc"
which "clang++" 1>/dev/null 2>&1 && dfltcxx="clang++" || dfltcxx="g++"
dfltfc="gfortran"
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
sedcmd='/^#line 0 ____FILE____/,$ { s/^(#line +0 +)____FILE____/\1"'"${this_bn%.*}"'"/ ; p ; }'
${SED:-sed} -nE -e "${sedcmd}" "${this}" |
  "${cmplr}" -x "${lang}" ${cmplr_flg} ${cpp_flg} ${cmpflgs_add} -o "${exectbl}" ${CCFLAGS} - ${LDFLAGS} ${ldflgs_add} ${LDLIBS} ${ldlibs_add} \
  &&  { if [ ${autorun:-1} -ne 0  ] ; then    "${exectbl}" "${@}"                               ; fi ; \
        if [ ${keep_bin:-0} -eq 0 ] ; then rm "${exectbl}"                                      ; fi ; \
        if [ ${keep_src:-0} -ne 0 ] ; then ${SED:-sed} -nE -e "${sedcmd}" "${this}" 1> "${src}" ; fi ; }
exit
# */
#line 0 ____FILE____
