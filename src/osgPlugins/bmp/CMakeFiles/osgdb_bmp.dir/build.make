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
include src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/depend.make

# Include the progress variables for this target.
include src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/progress.make

# Include the compile flags for this target's objects.
include src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/flags.make

src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o: src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/flags.make
src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o: src/osgPlugins/bmp/ReaderWriterBMP.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp/ReaderWriterBMP.cpp

src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp/ReaderWriterBMP.cpp > CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.i

src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp/ReaderWriterBMP.cpp -o CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.s

src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o.requires:
.PHONY : src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o.requires

src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o.provides: src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o.requires
	$(MAKE) -f src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/build.make src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o.provides.build
.PHONY : src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o.provides

src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o.provides.build: src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o

# Object files for target osgdb_bmp
osgdb_bmp_OBJECTS = \
"CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o"

# External object files for target osgdb_bmp
osgdb_bmp_EXTERNAL_OBJECTS =

lib/osgPlugins-3.1.0/osgdb_bmp.so: src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o
lib/osgPlugins-3.1.0/osgdb_bmp.so: lib/libOpenThreads.2.6.0.dylib
lib/osgPlugins-3.1.0/osgdb_bmp.so: lib/libosg.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_bmp.so: lib/libosgDB.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_bmp.so: lib/libosgUtil.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_bmp.so: lib/libosg.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_bmp.so: lib/libOpenThreads.2.6.0.dylib
lib/osgPlugins-3.1.0/osgdb_bmp.so: /usr/lib/libm.dylib
lib/osgPlugins-3.1.0/osgdb_bmp.so: /usr/lib/libdl.dylib
lib/osgPlugins-3.1.0/osgdb_bmp.so: /usr/lib/libz.dylib
lib/osgPlugins-3.1.0/osgdb_bmp.so: src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/build.make
lib/osgPlugins-3.1.0/osgdb_bmp.so: src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX shared module ../../../lib/osgPlugins-3.1.0/osgdb_bmp.so"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/osgdb_bmp.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/build: lib/osgPlugins-3.1.0/osgdb_bmp.so
.PHONY : src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/build

src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/requires: src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/ReaderWriterBMP.cpp.o.requires
.PHONY : src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/requires

src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/clean:
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp && $(CMAKE_COMMAND) -P CMakeFiles/osgdb_bmp.dir/cmake_clean.cmake
.PHONY : src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/clean

src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/depend:
	cd /Users/maurizio/work/t11/git/osg && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp /Users/maurizio/work/t11/git/osg/src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/osgPlugins/bmp/CMakeFiles/osgdb_bmp.dir/depend

