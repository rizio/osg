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
include src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/depend.make

# Include the progress variables for this target.
include src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/progress.make

# Include the compile flags for this target's objects.
include src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/flags.make

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/flags.make
src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o: src/osgPlugins/lws/ReaderWriterLWS.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws/ReaderWriterLWS.cpp

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws/ReaderWriterLWS.cpp > CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.i

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws/ReaderWriterLWS.cpp -o CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.s

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o.requires:
.PHONY : src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o.requires

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o.provides: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o.requires
	$(MAKE) -f src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/build.make src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o.provides.build
.PHONY : src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o.provides

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o.provides.build: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/flags.make
src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o: src/osgPlugins/lws/SceneLoader.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws/SceneLoader.cpp

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws/SceneLoader.cpp > CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.i

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws/SceneLoader.cpp -o CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.s

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o.requires:
.PHONY : src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o.requires

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o.provides: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o.requires
	$(MAKE) -f src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/build.make src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o.provides.build
.PHONY : src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o.provides

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o.provides.build: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o

# Object files for target osgdb_lws
osgdb_lws_OBJECTS = \
"CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o" \
"CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o"

# External object files for target osgdb_lws
osgdb_lws_EXTERNAL_OBJECTS =

lib/osgPlugins-3.1.0/osgdb_lws.so: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o
lib/osgPlugins-3.1.0/osgdb_lws.so: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o
lib/osgPlugins-3.1.0/osgdb_lws.so: lib/libOpenThreads.2.6.0.dylib
lib/osgPlugins-3.1.0/osgdb_lws.so: lib/libosg.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_lws.so: lib/libosgDB.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_lws.so: lib/libosgUtil.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_lws.so: lib/libosg.3.1.0.dylib
lib/osgPlugins-3.1.0/osgdb_lws.so: lib/libOpenThreads.2.6.0.dylib
lib/osgPlugins-3.1.0/osgdb_lws.so: /usr/lib/libm.dylib
lib/osgPlugins-3.1.0/osgdb_lws.so: /usr/lib/libdl.dylib
lib/osgPlugins-3.1.0/osgdb_lws.so: /usr/lib/libz.dylib
lib/osgPlugins-3.1.0/osgdb_lws.so: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/build.make
lib/osgPlugins-3.1.0/osgdb_lws.so: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX shared module ../../../lib/osgPlugins-3.1.0/osgdb_lws.so"
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/osgdb_lws.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/build: lib/osgPlugins-3.1.0/osgdb_lws.so
.PHONY : src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/build

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/requires: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/ReaderWriterLWS.cpp.o.requires
src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/requires: src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/SceneLoader.cpp.o.requires
.PHONY : src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/requires

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/clean:
	cd /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws && $(CMAKE_COMMAND) -P CMakeFiles/osgdb_lws.dir/cmake_clean.cmake
.PHONY : src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/clean

src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/depend:
	cd /Users/maurizio/work/t11/git/osg && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws /Users/maurizio/work/t11/git/osg/src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/osgPlugins/lws/CMakeFiles/osgdb_lws.dir/depend

