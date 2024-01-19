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
CMAKE_SOURCE_DIR = /home/mku/share/tool_source/z3_mur

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/mku/tools/z3_59e9c87

# Include any dependencies generated for this target.
include src/math/simplex/CMakeFiles/simplex.dir/depend.make

# Include the progress variables for this target.
include src/math/simplex/CMakeFiles/simplex.dir/progress.make

# Include the compile flags for this target's objects.
include src/math/simplex/CMakeFiles/simplex.dir/flags.make

src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o: src/math/simplex/CMakeFiles/simplex.dir/flags.make
src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o: /home/mku/share/tool_source/z3_mur/src/math/simplex/simplex.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/mku/tools/z3_59e9c87/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o"
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/simplex.dir/simplex.cpp.o -c /home/mku/share/tool_source/z3_mur/src/math/simplex/simplex.cpp

src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/simplex.dir/simplex.cpp.i"
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/mku/share/tool_source/z3_mur/src/math/simplex/simplex.cpp > CMakeFiles/simplex.dir/simplex.cpp.i

src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/simplex.dir/simplex.cpp.s"
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/mku/share/tool_source/z3_mur/src/math/simplex/simplex.cpp -o CMakeFiles/simplex.dir/simplex.cpp.s

src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o.requires:

.PHONY : src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o.requires

src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o.provides: src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o.requires
	$(MAKE) -f src/math/simplex/CMakeFiles/simplex.dir/build.make src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o.provides.build
.PHONY : src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o.provides

src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o.provides.build: src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o


src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o: src/math/simplex/CMakeFiles/simplex.dir/flags.make
src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o: /home/mku/share/tool_source/z3_mur/src/math/simplex/model_based_opt.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/mku/tools/z3_59e9c87/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o"
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/simplex.dir/model_based_opt.cpp.o -c /home/mku/share/tool_source/z3_mur/src/math/simplex/model_based_opt.cpp

src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/simplex.dir/model_based_opt.cpp.i"
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/mku/share/tool_source/z3_mur/src/math/simplex/model_based_opt.cpp > CMakeFiles/simplex.dir/model_based_opt.cpp.i

src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/simplex.dir/model_based_opt.cpp.s"
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/mku/share/tool_source/z3_mur/src/math/simplex/model_based_opt.cpp -o CMakeFiles/simplex.dir/model_based_opt.cpp.s

src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o.requires:

.PHONY : src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o.requires

src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o.provides: src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o.requires
	$(MAKE) -f src/math/simplex/CMakeFiles/simplex.dir/build.make src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o.provides.build
.PHONY : src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o.provides

src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o.provides.build: src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o


src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o: src/math/simplex/CMakeFiles/simplex.dir/flags.make
src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o: /home/mku/share/tool_source/z3_mur/src/math/simplex/bit_matrix.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/mku/tools/z3_59e9c87/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o"
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/simplex.dir/bit_matrix.cpp.o -c /home/mku/share/tool_source/z3_mur/src/math/simplex/bit_matrix.cpp

src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/simplex.dir/bit_matrix.cpp.i"
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/mku/share/tool_source/z3_mur/src/math/simplex/bit_matrix.cpp > CMakeFiles/simplex.dir/bit_matrix.cpp.i

src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/simplex.dir/bit_matrix.cpp.s"
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/mku/share/tool_source/z3_mur/src/math/simplex/bit_matrix.cpp -o CMakeFiles/simplex.dir/bit_matrix.cpp.s

src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o.requires:

.PHONY : src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o.requires

src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o.provides: src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o.requires
	$(MAKE) -f src/math/simplex/CMakeFiles/simplex.dir/build.make src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o.provides.build
.PHONY : src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o.provides

src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o.provides.build: src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o


simplex: src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o
simplex: src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o
simplex: src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o
simplex: src/math/simplex/CMakeFiles/simplex.dir/build.make

.PHONY : simplex

# Rule to build all files generated by this target.
src/math/simplex/CMakeFiles/simplex.dir/build: simplex

.PHONY : src/math/simplex/CMakeFiles/simplex.dir/build

src/math/simplex/CMakeFiles/simplex.dir/requires: src/math/simplex/CMakeFiles/simplex.dir/simplex.cpp.o.requires
src/math/simplex/CMakeFiles/simplex.dir/requires: src/math/simplex/CMakeFiles/simplex.dir/model_based_opt.cpp.o.requires
src/math/simplex/CMakeFiles/simplex.dir/requires: src/math/simplex/CMakeFiles/simplex.dir/bit_matrix.cpp.o.requires

.PHONY : src/math/simplex/CMakeFiles/simplex.dir/requires

src/math/simplex/CMakeFiles/simplex.dir/clean:
	cd /home/mku/tools/z3_59e9c87/src/math/simplex && $(CMAKE_COMMAND) -P CMakeFiles/simplex.dir/cmake_clean.cmake
.PHONY : src/math/simplex/CMakeFiles/simplex.dir/clean

src/math/simplex/CMakeFiles/simplex.dir/depend:
	cd /home/mku/tools/z3_59e9c87 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/mku/share/tool_source/z3_mur /home/mku/share/tool_source/z3_mur/src/math/simplex /home/mku/tools/z3_59e9c87 /home/mku/tools/z3_59e9c87/src/math/simplex /home/mku/tools/z3_59e9c87/src/math/simplex/CMakeFiles/simplex.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/math/simplex/CMakeFiles/simplex.dir/depend
