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
include src/osgFX/CMakeFiles/osgFX.dir/depend.make

# Include the progress variables for this target.
include src/osgFX/CMakeFiles/osgFX.dir/progress.make

# Include the compile flags for this target's objects.
include src/osgFX/CMakeFiles/osgFX.dir/flags.make

src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o: src/osgFX/AnisotropicLighting.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/AnisotropicLighting.cpp

src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/AnisotropicLighting.cpp > CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/AnisotropicLighting.cpp -o CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o: src/osgFX/BumpMapping.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/BumpMapping.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/BumpMapping.cpp

src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/BumpMapping.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/BumpMapping.cpp > CMakeFiles/osgFX.dir/BumpMapping.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/BumpMapping.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/BumpMapping.cpp -o CMakeFiles/osgFX.dir/BumpMapping.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o: src/osgFX/Cartoon.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_3)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/Cartoon.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/Cartoon.cpp

src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/Cartoon.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/Cartoon.cpp > CMakeFiles/osgFX.dir/Cartoon.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/Cartoon.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/Cartoon.cpp -o CMakeFiles/osgFX.dir/Cartoon.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o: src/osgFX/Effect.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_4)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/Effect.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/Effect.cpp

src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/Effect.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/Effect.cpp > CMakeFiles/osgFX.dir/Effect.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/Effect.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/Effect.cpp -o CMakeFiles/osgFX.dir/Effect.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o: src/osgFX/MultiTextureControl.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_5)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/MultiTextureControl.cpp

src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/MultiTextureControl.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/MultiTextureControl.cpp > CMakeFiles/osgFX.dir/MultiTextureControl.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/MultiTextureControl.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/MultiTextureControl.cpp -o CMakeFiles/osgFX.dir/MultiTextureControl.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o: src/osgFX/Outline.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_6)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/Outline.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/Outline.cpp

src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/Outline.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/Outline.cpp > CMakeFiles/osgFX.dir/Outline.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/Outline.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/Outline.cpp -o CMakeFiles/osgFX.dir/Outline.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o: src/osgFX/Registry.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_7)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/Registry.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/Registry.cpp

src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/Registry.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/Registry.cpp > CMakeFiles/osgFX.dir/Registry.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/Registry.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/Registry.cpp -o CMakeFiles/osgFX.dir/Registry.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o: src/osgFX/Scribe.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_8)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/Scribe.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/Scribe.cpp

src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/Scribe.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/Scribe.cpp > CMakeFiles/osgFX.dir/Scribe.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/Scribe.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/Scribe.cpp -o CMakeFiles/osgFX.dir/Scribe.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o: src/osgFX/SpecularHighlights.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_9)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/SpecularHighlights.cpp

src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/SpecularHighlights.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/SpecularHighlights.cpp > CMakeFiles/osgFX.dir/SpecularHighlights.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/SpecularHighlights.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/SpecularHighlights.cpp -o CMakeFiles/osgFX.dir/SpecularHighlights.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o: src/osgFX/Technique.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_10)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/Technique.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/Technique.cpp

src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/Technique.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/Technique.cpp > CMakeFiles/osgFX.dir/Technique.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/Technique.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/Technique.cpp -o CMakeFiles/osgFX.dir/Technique.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o: src/osgFX/Validator.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_11)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/Validator.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/Validator.cpp

src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/Validator.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/Validator.cpp > CMakeFiles/osgFX.dir/Validator.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/Validator.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/Validator.cpp -o CMakeFiles/osgFX.dir/Validator.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o

src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o: src/osgFX/CMakeFiles/osgFX.dir/flags.make
src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o: src/osgFX/Version.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/maurizio/work/t11/git/osg/CMakeFiles $(CMAKE_PROGRESS_12)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/osgFX.dir/Version.cpp.o -c /Users/maurizio/work/t11/git/osg/src/osgFX/Version.cpp

src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/osgFX.dir/Version.cpp.i"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/maurizio/work/t11/git/osg/src/osgFX/Version.cpp > CMakeFiles/osgFX.dir/Version.cpp.i

src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/osgFX.dir/Version.cpp.s"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/maurizio/work/t11/git/osg/src/osgFX/Version.cpp -o CMakeFiles/osgFX.dir/Version.cpp.s

src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o.requires:
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o.requires

src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o.provides: src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o.requires
	$(MAKE) -f src/osgFX/CMakeFiles/osgFX.dir/build.make src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o.provides.build
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o.provides

src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o.provides.build: src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o

# Object files for target osgFX
osgFX_OBJECTS = \
"CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o" \
"CMakeFiles/osgFX.dir/BumpMapping.cpp.o" \
"CMakeFiles/osgFX.dir/Cartoon.cpp.o" \
"CMakeFiles/osgFX.dir/Effect.cpp.o" \
"CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o" \
"CMakeFiles/osgFX.dir/Outline.cpp.o" \
"CMakeFiles/osgFX.dir/Registry.cpp.o" \
"CMakeFiles/osgFX.dir/Scribe.cpp.o" \
"CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o" \
"CMakeFiles/osgFX.dir/Technique.cpp.o" \
"CMakeFiles/osgFX.dir/Validator.cpp.o" \
"CMakeFiles/osgFX.dir/Version.cpp.o"

# External object files for target osgFX
osgFX_EXTERNAL_OBJECTS =

lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o
lib/libosgFX.3.1.0.dylib: lib/libosgUtil.3.1.0.dylib
lib/libosgFX.3.1.0.dylib: lib/libosgDB.3.1.0.dylib
lib/libosgFX.3.1.0.dylib: lib/libosg.3.1.0.dylib
lib/libosgFX.3.1.0.dylib: lib/libOpenThreads.2.6.0.dylib
lib/libosgFX.3.1.0.dylib: lib/libosgUtil.3.1.0.dylib
lib/libosgFX.3.1.0.dylib: lib/libosg.3.1.0.dylib
lib/libosgFX.3.1.0.dylib: /usr/lib/libm.dylib
lib/libosgFX.3.1.0.dylib: lib/libOpenThreads.2.6.0.dylib
lib/libosgFX.3.1.0.dylib: /usr/lib/libdl.dylib
lib/libosgFX.3.1.0.dylib: /usr/lib/libz.dylib
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/build.make
lib/libosgFX.3.1.0.dylib: src/osgFX/CMakeFiles/osgFX.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX shared library ../../lib/libosgFX.dylib"
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/osgFX.dir/link.txt --verbose=$(VERBOSE)
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && $(CMAKE_COMMAND) -E cmake_symlink_library ../../lib/libosgFX.3.1.0.dylib ../../lib/libosgFX.78.dylib ../../lib/libosgFX.dylib

lib/libosgFX.78.dylib: lib/libosgFX.3.1.0.dylib

lib/libosgFX.dylib: lib/libosgFX.3.1.0.dylib

# Rule to build all files generated by this target.
src/osgFX/CMakeFiles/osgFX.dir/build: lib/libosgFX.dylib
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/build

src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/AnisotropicLighting.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/BumpMapping.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/Cartoon.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/Effect.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/MultiTextureControl.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/Outline.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/Registry.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/Scribe.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/SpecularHighlights.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/Technique.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/Validator.cpp.o.requires
src/osgFX/CMakeFiles/osgFX.dir/requires: src/osgFX/CMakeFiles/osgFX.dir/Version.cpp.o.requires
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/requires

src/osgFX/CMakeFiles/osgFX.dir/clean:
	cd /Users/maurizio/work/t11/git/osg/src/osgFX && $(CMAKE_COMMAND) -P CMakeFiles/osgFX.dir/cmake_clean.cmake
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/clean

src/osgFX/CMakeFiles/osgFX.dir/depend:
	cd /Users/maurizio/work/t11/git/osg && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/osgFX /Users/maurizio/work/t11/git/osg /Users/maurizio/work/t11/git/osg/src/osgFX /Users/maurizio/work/t11/git/osg/src/osgFX/CMakeFiles/osgFX.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/osgFX/CMakeFiles/osgFX.dir/depend

