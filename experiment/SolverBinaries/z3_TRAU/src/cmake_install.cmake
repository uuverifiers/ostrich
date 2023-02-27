# Install script for directory: /home/mku/share/tool_source/z3_TRAU/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libz3.so.4.8.7.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libz3.so.4.8"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libz3.so"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/mku/tools/z3_TRAU/libz3.so.4.8.7.0"
    "/home/mku/tools/z3_TRAU/libz3.so.4.8"
    "/home/mku/tools/z3_TRAU/libz3.so"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libz3.so.4.8.7.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libz3.so.4.8"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libz3.so"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_algebraic.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_api.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_ast_containers.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_fixedpoint.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_fpa.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/c++/z3++.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_macros.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_optimization.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_polynomial.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_rcf.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_v1.h"
    "/home/mku/share/tool_source/z3_TRAU/src/api/z3_spacer.h"
    "/home/mku/tools/z3_TRAU/src/util/z3_version.h"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/mku/tools/z3_TRAU/src/util/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/polynomial/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/sat/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/nlsat/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/util/lp/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/hilbert/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/simplex/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/automata/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/interval/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/realclosure/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/subpaving/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ast/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ast/rewriter/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ast/normal_forms/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/model/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ast/substitution/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/parsers/util/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/grobner/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/euclid/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/core/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/math/subpaving/tactic/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/aig/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/solver/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/sat/tactic/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/arith/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/nlsat/tactic/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ackermannization/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/cmd_context/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/cmd_context/extra_cmds/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/parsers/smt2/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ast/proofs/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ast/fpa/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ast/macros/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ast/pattern/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/ast/rewriter/bit_blaster/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/smt/params/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/smt/proto_model/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/smt/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/bv/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/smt/tactic/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/sls/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/qe/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/base/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/dataflow/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/transforms/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/rel/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/clp/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/tab/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/bmc/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/ddnf/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/spacer/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/muz/fp/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/ufbv/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/sat/sat_solver/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/smtlogics/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/fpa/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/fd_solver/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/tactic/portfolio/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/opt/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/api/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/api/dll/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/shell/cmake_install.cmake")
  include("/home/mku/tools/z3_TRAU/src/test/cmake_install.cmake")

endif()

