# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canoncical targets will work.
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
CMAKE_COMMAND = "/Applications/CMake 2.8-6.app/Contents/bin/cmake"

# The command to remove a file.
RM = "/Applications/CMake 2.8-6.app/Contents/bin/cmake" -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = "/Applications/CMake 2.8-6.app/Contents/bin/ccmake"

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/maurizio/work/t11/git/osg

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/maurizio/work/t11/git/osg

# Include any dependencies generated for this target.
include src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/depend.make

# Include the progress variables for this target.
include src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/progress.make

# Include the compile flags for this target's objects.
include src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/flags.make

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/flags.make
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o: src/OpenThreads/pthreads/PThread.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/OpenThreads.dir/PThread.cpp.o -c /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThread.cpp

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/OpenThreads.dir/PThread.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThread.cpp > CMakeFiles/OpenThreads.dir/PThread.cpp.i

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/OpenThreads.dir/PThread.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThread.cpp -o CMakeFiles/OpenThreads.dir/PThread.cpp.s

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o.requires:
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o.requires

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o.provides: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o.requires
	$(MAKE) -f src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/build.make src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o.provides.build
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o.provides

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o.provides.build: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/flags.make
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o: src/OpenThreads/pthreads/PThreadBarrier.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o -c /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThreadBarrier.cpp

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThreadBarrier.cpp > CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.i

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThreadBarrier.cpp -o CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.s

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o.requires:
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o.requires

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o.provides: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o.requires
	$(MAKE) -f src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/build.make src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o.provides.build
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o.provides

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o.provides.build: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/flags.make
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o: src/OpenThreads/pthreads/PThreadCondition.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_3)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o -c /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThreadCondition.cpp

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThreadCondition.cpp > CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.i

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThreadCondition.cpp -o CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.s

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o.requires:
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o.requires

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o.provides: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o.requires
	$(MAKE) -f src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/build.make src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o.provides.build
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o.provides

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o.provides.build: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/flags.make
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o: src/OpenThreads/pthreads/PThreadMutex.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_4)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o -c /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThreadMutex.cpp

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThreadMutex.cpp > CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.i

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/PThreadMutex.cpp -o CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.s

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o.requires:
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o.requires

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o.provides: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o.requires
	$(MAKE) -f src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/build.make src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o.provides.build
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o.provides

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o.provides.build: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/flags.make
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o: src/OpenThreads/common/Version.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_5)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o -c /Users/maurizio/work/t11/git/osg/src/OpenThreads/common/Version.cpp

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/OpenThreads.dir/__/common/Version.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/OpenThreads/common/Version.cpp > CMakeFiles/OpenThreads.dir/__/common/Version.cpp.i

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/OpenThreads.dir/__/common/Version.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/OpenThreads/common/Version.cpp -o CMakeFiles/OpenThreads.dir/__/common/Version.cpp.s

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o.requires:
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o.requires

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o.provides: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o.requires
	$(MAKE) -f src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/build.make src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o.provides.build
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o.provides

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o.provides.build: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/flags.make
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o: src/OpenThreads/common/Atomic.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_6)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o -c /Users/maurizio/work/t11/git/osg/src/OpenThreads/common/Atomic.cpp

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/OpenThreads/common/Atomic.cpp > CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.i

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/OpenThreads/common/Atomic.cpp -o CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.s

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o.requires:
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o.requires

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o.provides: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o.requires
	$(MAKE) -f src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/build.make src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o.provides.build
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o.provides

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o.provides.build: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o

# Object files for target OpenThreads
OpenThreads_OBJECTS = \
"CMakeFiles/OpenThreads.dir/PThread.cpp.o" \
"CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o" \
"CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o" \
"CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o" \
"CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o" \
"CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o"

# External object files for target OpenThreads
OpenThreads_EXTERNAL_OBJECTS =

lib/libOpenThreads.2.6.0.dylib: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o
lib/libOpenThreads.2.6.0.dylib: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o
lib/libOpenThreads.2.6.0.dylib: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o
lib/libOpenThreads.2.6.0.dylib: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o
lib/libOpenThreads.2.6.0.dylib: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o
lib/libOpenThreads.2.6.0.dylib: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o
lib/libOpenThreads.2.6.0.dylib: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/build.make
lib/libOpenThreads.2.6.0.dylib: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX shared library ../../../lib/libOpenThreads.dylib"
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/OpenThreads.dir/link.txt --verbose=$(VERBOSE)
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && $(CMAKE_COMMAND) -E cmake_symlink_library ../../../lib/libOpenThreads.2.6.0.dylib ../../../lib/libOpenThreads.12.dylib ../../../lib/libOpenThreads.dylib

lib/libOpenThreads.12.dylib: lib/libOpenThreads.2.6.0.dylib

lib/libOpenThreads.dylib: lib/libOpenThreads.2.6.0.dylib

# Rule to build all files generated by this target.
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/build: lib/libOpenThreads.dylib
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/build

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/requires: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThread.cpp.o.requires
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/requires: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadBarrier.cpp.o.requires
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/requires: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadCondition.cpp.o.requires
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/requires: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/PThreadMutex.cpp.o.requires
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/requires: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Version.cpp.o.requires
src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/requires: src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/__/common/Atomic.cpp.o.requires
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/requires

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/clean:
	cd /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads && $(CMAKE_COMMAND) -P CMakeFiles/OpenThreads.dir/cmake_clean.cmake
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/clean

src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/depend:
	cd /Users/maurizio/work/t11/git/osg && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads /Users/maurizio/work/t11/git/osg/src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/OpenThreads/pthreads/CMakeFiles/OpenThreads.dir/depend

