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
include src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/depend.make

# Include the progress variables for this target.
include src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/progress.make

# Include the compile flags for this target's objects.
include src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/flags.make

src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o: src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/flags.make
src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o: src/osgPlugins/imageio/ReaderWriterImageIO.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio/ReaderWriterImageIO.cpp

src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio/ReaderWriterImageIO.cpp > CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.i

src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio/ReaderWriterImageIO.cpp -o CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.s

src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o.requires:
.PHONY : src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o.requires

src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o.provides: src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o.requires
	$(MAKE) -f src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/build.make src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o.provides.build
.PHONY : src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o.provides

src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o.provides.build: src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o

# Object files for target osgdb_imageio
osgdb_imageio_OBJECTS = \
"CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o"

# External object files for target osgdb_imageio
osgdb_imageio_EXTERNAL_OBJECTS =

lib/osgPlugins-3.1.0/osgdb_imageio.so: src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o
lib/osgPlugins-3.1.0/osgdb_imageio.so: lib/libOpenThreads.2.6.0.dylib
lib/osgPlugins-3.1.0/osgdb_imageio.so: lib/libosg.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_imageio.so: lib/libosgDB.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_imageio.so: lib/libosgUtil.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_imageio.so: lib/libosg.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_imageio.so: lib/libOpenThreads.2.6.0.dylib
lib/osgPlugins-3.1.0/osgdb_imageio.so: /usr/lib/libm.dylib
lib/osgPlugins-3.1.0/osgdb_imageio.so: /usr/lib/libdl.dylib
lib/osgPlugins-3.1.0/osgdb_imageio.so: /usr/lib/libz.dylib
lib/osgPlugins-3.1.0/osgdb_imageio.so: src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/build.make
lib/osgPlugins-3.1.0/osgdb_imageio.so: src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX shared module ../../../lib/osgPlugins-3.1.0/osgdb_imageio.so"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/osgdb_imageio.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/build: lib/osgPlugins-3.1.0/osgdb_imageio.so
.PHONY : src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/build

src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/requires: src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/ReaderWriterImageIO.cpp.o.requires
.PHONY : src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/requires

src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/clean:
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio && $(CMAKE_COMMAND) -P CMakeFiles/osgdb_imageio.dir/cmake_clean.cmake
.PHONY : src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/clean

src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/depend:
	cd /Users/maurizio/work/t11/git/osg && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio /Users/maurizio/work/t11/git/osg/src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/osgPlugins/imageio/CMakeFiles/osgdb_imageio.dir/depend

