# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/mku/share/tool_source/z3_TRAU

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/mku/tools/z3_TRAU

# Include any dependencies generated for this target.
include src/muz/fp/CMakeFiles/fp.dir/depend.make

# Include the progress variables for this target.
include src/muz/fp/CMakeFiles/fp.dir/progress.make

# Include the compile flags for this target's objects.
include src/muz/fp/CMakeFiles/fp.dir/flags.make

src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o: src/muz/fp/CMakeFiles/fp.dir/flags.make
src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o: /home/mku/share/tool_source/z3_TRAU/src/muz/fp/datalog_parser.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/mku/tools/z3_TRAU/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/fp.dir/datalog_parser.cpp.o -c /home/mku/share/tool_source/z3_TRAU/src/muz/fp/datalog_parser.cpp

src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/fp.dir/datalog_parser.cpp.i"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/mku/share/tool_source/z3_TRAU/src/muz/fp/datalog_parser.cpp > CMakeFiles/fp.dir/datalog_parser.cpp.i

src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/fp.dir/datalog_parser.cpp.s"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/mku/share/tool_source/z3_TRAU/src/muz/fp/datalog_parser.cpp -o CMakeFiles/fp.dir/datalog_parser.cpp.s

src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o.requires:

.PHONY : src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o.requires

src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o.provides: src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o.requires
	$(MAKE) -f src/muz/fp/CMakeFiles/fp.dir/build.make src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o.provides.build
.PHONY : src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o.provides

src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o.provides.build: src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o


src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o: src/muz/fp/CMakeFiles/fp.dir/flags.make
src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o: /home/mku/share/tool_source/z3_TRAU/src/muz/fp/dl_cmds.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/mku/tools/z3_TRAU/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/fp.dir/dl_cmds.cpp.o -c /home/mku/share/tool_source/z3_TRAU/src/muz/fp/dl_cmds.cpp

src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/fp.dir/dl_cmds.cpp.i"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/mku/share/tool_source/z3_TRAU/src/muz/fp/dl_cmds.cpp > CMakeFiles/fp.dir/dl_cmds.cpp.i

src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/fp.dir/dl_cmds.cpp.s"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/mku/share/tool_source/z3_TRAU/src/muz/fp/dl_cmds.cpp -o CMakeFiles/fp.dir/dl_cmds.cpp.s

src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o.requires:

.PHONY : src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o.requires

src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o.provides: src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o.requires
	$(MAKE) -f src/muz/fp/CMakeFiles/fp.dir/build.make src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o.provides.build
.PHONY : src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o.provides

src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o.provides.build: src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o


src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o: src/muz/fp/CMakeFiles/fp.dir/flags.make
src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o: /home/mku/share/tool_source/z3_TRAU/src/muz/fp/dl_register_engine.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/mku/tools/z3_TRAU/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/fp.dir/dl_register_engine.cpp.o -c /home/mku/share/tool_source/z3_TRAU/src/muz/fp/dl_register_engine.cpp

src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/fp.dir/dl_register_engine.cpp.i"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/mku/share/tool_source/z3_TRAU/src/muz/fp/dl_register_engine.cpp > CMakeFiles/fp.dir/dl_register_engine.cpp.i

src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/fp.dir/dl_register_engine.cpp.s"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/mku/share/tool_source/z3_TRAU/src/muz/fp/dl_register_engine.cpp -o CMakeFiles/fp.dir/dl_register_engine.cpp.s

src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o.requires:

.PHONY : src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o.requires

src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o.provides: src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o.requires
	$(MAKE) -f src/muz/fp/CMakeFiles/fp.dir/build.make src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o.provides.build
.PHONY : src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o.provides

src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o.provides.build: src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o


src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o: src/muz/fp/CMakeFiles/fp.dir/flags.make
src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o: /home/mku/share/tool_source/z3_TRAU/src/muz/fp/horn_tactic.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/mku/tools/z3_TRAU/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/fp.dir/horn_tactic.cpp.o -c /home/mku/share/tool_source/z3_TRAU/src/muz/fp/horn_tactic.cpp

src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/fp.dir/horn_tactic.cpp.i"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/mku/share/tool_source/z3_TRAU/src/muz/fp/horn_tactic.cpp > CMakeFiles/fp.dir/horn_tactic.cpp.i

src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/fp.dir/horn_tactic.cpp.s"
	cd /home/mku/tools/z3_TRAU/src/muz/fp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/mku/share/tool_source/z3_TRAU/src/muz/fp/horn_tactic.cpp -o CMakeFiles/fp.dir/horn_tactic.cpp.s

src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o.requires:

.PHONY : src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o.requires

src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o.provides: src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o.requires
	$(MAKE) -f src/muz/fp/CMakeFiles/fp.dir/build.make src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o.provides.build
.PHONY : src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o.provides

src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o.provides.build: src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o


fp: src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o
fp: src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o
fp: src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o
fp: src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o
fp: src/muz/fp/CMakeFiles/fp.dir/build.make

.PHONY : fp

# Rule to build all files generated by this target.
src/muz/fp/CMakeFiles/fp.dir/build: fp

.PHONY : src/muz/fp/CMakeFiles/fp.dir/build

src/muz/fp/CMakeFiles/fp.dir/requires: src/muz/fp/CMakeFiles/fp.dir/datalog_parser.cpp.o.requires
src/muz/fp/CMakeFiles/fp.dir/requires: src/muz/fp/CMakeFiles/fp.dir/dl_cmds.cpp.o.requires
src/muz/fp/CMakeFiles/fp.dir/requires: src/muz/fp/CMakeFiles/fp.dir/dl_register_engine.cpp.o.requires
src/muz/fp/CMakeFiles/fp.dir/requires: src/muz/fp/CMakeFiles/fp.dir/horn_tactic.cpp.o.requires

.PHONY : src/muz/fp/CMakeFiles/fp.dir/requires

src/muz/fp/CMakeFiles/fp.dir/clean:
	cd /home/mku/tools/z3_TRAU/src/muz/fp && $(CMAKE_COMMAND) -P CMakeFiles/fp.dir/cmake_clean.cmake
.PHONY : src/muz/fp/CMakeFiles/fp.dir/clean

src/muz/fp/CMakeFiles/fp.dir/depend:
	cd /home/mku/tools/z3_TRAU && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/mku/share/tool_source/z3_TRAU /home/mku/share/tool_source/z3_TRAU/src/muz/fp /home/mku/tools/z3_TRAU /home/mku/tools/z3_TRAU/src/muz/fp /home/mku/tools/z3_TRAU/src/muz/fp/CMakeFiles/fp.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/muz/fp/CMakeFiles/fp.dir/depend
