# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.19

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/sahil/.local/bin/cmake

# The command to remove a file.
RM = /home/sahil/.local/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build

# Include any dependencies generated for this target.
include external/CMakeFiles/p3protolib.dir/depend.make

# Include the progress variables for this target.
include external/CMakeFiles/p3protolib.dir/progress.make

# Include the compile flags for this target's objects.
include external/CMakeFiles/p3protolib.dir/flags.make

external/protos/store.pb.cc: ../../external/protos/store.proto
external/protos/store.pb.cc: ../../external/protos/vendor.proto
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating proto messages ..."
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/protoc --proto_path=/home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/external --cpp_out=/home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external --plugin=protoc-gen-grpc=/usr/bin/grpc_cpp_plugin --grpc_out=/home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/external/protos/store.proto /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/external/protos/vendor.proto

external/protos/store.grpc.pb.cc: external/protos/store.pb.cc
	@$(CMAKE_COMMAND) -E touch_nocreate external/protos/store.grpc.pb.cc

external/protos/vendor.pb.cc: external/protos/store.pb.cc
	@$(CMAKE_COMMAND) -E touch_nocreate external/protos/vendor.pb.cc

external/protos/vendor.grpc.pb.cc: external/protos/store.pb.cc
	@$(CMAKE_COMMAND) -E touch_nocreate external/protos/vendor.grpc.pb.cc

external/protos/store.pb.h: external/protos/store.pb.cc
	@$(CMAKE_COMMAND) -E touch_nocreate external/protos/store.pb.h

external/protos/store.grpc.pb.h: external/protos/store.pb.cc
	@$(CMAKE_COMMAND) -E touch_nocreate external/protos/store.grpc.pb.h

external/protos/vendor.pb.h: external/protos/store.pb.cc
	@$(CMAKE_COMMAND) -E touch_nocreate external/protos/vendor.pb.h

external/protos/vendor.grpc.pb.h: external/protos/store.pb.cc
	@$(CMAKE_COMMAND) -E touch_nocreate external/protos/vendor.grpc.pb.h

external/CMakeFiles/p3protolib.dir/protos/store.pb.cc.o: external/CMakeFiles/p3protolib.dir/flags.make
external/CMakeFiles/p3protolib.dir/protos/store.pb.cc.o: external/protos/store.pb.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object external/CMakeFiles/p3protolib.dir/protos/store.pb.cc.o"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/p3protolib.dir/protos/store.pb.cc.o -c /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/store.pb.cc

external/CMakeFiles/p3protolib.dir/protos/store.pb.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/p3protolib.dir/protos/store.pb.cc.i"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/store.pb.cc > CMakeFiles/p3protolib.dir/protos/store.pb.cc.i

external/CMakeFiles/p3protolib.dir/protos/store.pb.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/p3protolib.dir/protos/store.pb.cc.s"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/store.pb.cc -o CMakeFiles/p3protolib.dir/protos/store.pb.cc.s

external/CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.o: external/CMakeFiles/p3protolib.dir/flags.make
external/CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.o: external/protos/store.grpc.pb.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object external/CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.o"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.o -c /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/store.grpc.pb.cc

external/CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.i"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/store.grpc.pb.cc > CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.i

external/CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.s"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/store.grpc.pb.cc -o CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.s

external/CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.o: external/CMakeFiles/p3protolib.dir/flags.make
external/CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.o: external/protos/vendor.pb.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object external/CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.o"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.o -c /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/vendor.pb.cc

external/CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.i"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/vendor.pb.cc > CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.i

external/CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.s"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/vendor.pb.cc -o CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.s

external/CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.o: external/CMakeFiles/p3protolib.dir/flags.make
external/CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.o: external/protos/vendor.grpc.pb.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object external/CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.o"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.o -c /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/vendor.grpc.pb.cc

external/CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.i"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/vendor.grpc.pb.cc > CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.i

external/CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.s"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/protos/vendor.grpc.pb.cc -o CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.s

# Object files for target p3protolib
p3protolib_OBJECTS = \
"CMakeFiles/p3protolib.dir/protos/store.pb.cc.o" \
"CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.o" \
"CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.o" \
"CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.o"

# External object files for target p3protolib
p3protolib_EXTERNAL_OBJECTS =

external/libp3protolib.a: external/CMakeFiles/p3protolib.dir/protos/store.pb.cc.o
external/libp3protolib.a: external/CMakeFiles/p3protolib.dir/protos/store.grpc.pb.cc.o
external/libp3protolib.a: external/CMakeFiles/p3protolib.dir/protos/vendor.pb.cc.o
external/libp3protolib.a: external/CMakeFiles/p3protolib.dir/protos/vendor.grpc.pb.cc.o
external/libp3protolib.a: external/CMakeFiles/p3protolib.dir/build.make
external/libp3protolib.a: external/CMakeFiles/p3protolib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Linking CXX static library libp3protolib.a"
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && $(CMAKE_COMMAND) -P CMakeFiles/p3protolib.dir/cmake_clean_target.cmake
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/p3protolib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
external/CMakeFiles/p3protolib.dir/build: external/libp3protolib.a

.PHONY : external/CMakeFiles/p3protolib.dir/build

external/CMakeFiles/p3protolib.dir/clean:
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external && $(CMAKE_COMMAND) -P CMakeFiles/p3protolib.dir/cmake_clean.cmake
.PHONY : external/CMakeFiles/p3protolib.dir/clean

external/CMakeFiles/p3protolib.dir/depend: external/protos/store.grpc.pb.cc
external/CMakeFiles/p3protolib.dir/depend: external/protos/store.grpc.pb.h
external/CMakeFiles/p3protolib.dir/depend: external/protos/store.pb.cc
external/CMakeFiles/p3protolib.dir/depend: external/protos/store.pb.h
external/CMakeFiles/p3protolib.dir/depend: external/protos/vendor.grpc.pb.cc
external/CMakeFiles/p3protolib.dir/depend: external/protos/vendor.grpc.pb.h
external/CMakeFiles/p3protolib.dir/depend: external/protos/vendor.pb.cc
external/CMakeFiles/p3protolib.dir/depend: external/protos/vendor.pb.h
	cd /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/external /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external /home/sahil/Desktop/AOS-Assignments/Assignment3/project3-docker/cmake/build/external/CMakeFiles/p3protolib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : external/CMakeFiles/p3protolib.dir/depend

