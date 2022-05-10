###################
## >>>> BUILD COMMANDS (pass `-DDOWNLOAD=TRUE` to download AI models)
##
## $ mkdir build;
## $ cmake -S . -B build/ -DDOWNLOAD=TRUE
## $ make -C build/
##
##
###################
## >>>> EXECUTABLE COMMANDS
##
## $ make -C build/ run
## $ make -C build/ clean
## $ make -C build/ fresh
##
##

###################
# g++ setup
message(STATUS CMakeLists.txt[start] ----------------------)

cmake_minimum_required(VERSION 3.1.0)
project(demo)

# Make project require C++11
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
endif()

set(INTEL_OPENVINO_DIR /opt/intel/deployment_tools)
message(STATUS INTEL_OPENVINO_DIR: ${INTEL_OPENVINO_DIR})

###################
# include files: <-I /path/to/lib

file(GLOB srcfiles
        ${PROJECT_SOURCE_DIR}/*.cpp
        ${PROJECT_SOURCE_DIR}/*.hpp
        ${PROJECT_SOURCE_DIR}/rs-vino/*.cpp
        ${PROJECT_SOURCE_DIR}/rs-vino/*.h
        )


###################
# Create package Variables

# OpenCV_LIBS, OpenCV_COMPONENTS_REQUIRED, OpenCV_LIB_COMPONENTS, OpenCV_VERSION
include(cmake-modules/OpenCV.cmake)

# realsense2=`pkg-config --cflags --libs realsense2`
find_package(realsense2 CONFIG REQUIRED)
message(STATUS realsense2 libraries: (${realsense2_LIBRARY}) )

### include <easylogging++.h>
include(cmake-modules/Logging.cmake)

## #include <ngraph/ngraph.hpp>
include(cmake-modules/ngraphConfig.cmake)
message(STATUS NGRAPH_LIBRARIES: ${NGRAPH_LIBRARIES})

################################

include(cmake-modules/check_vino_version.cmake)
check_vino_version()

###################
# Create executable

# g++ <>
add_executable(${PROJECT_NAME}
        ${srcfiles}
        )

# library linking: <-l libname>
target_link_libraries(${PROJECT_NAME}
        PRIVATE ${InferenceEngine_LIBRARIES}
        ${OpenCV_LIBS}
        ${realsense2_LIBRARY}
        ${RS_LIBS}
        pthread)

###################
# CUSTOM COMMANDS: make <cmd>

# make fresh
add_custom_target(fresh
        COMMAND rm -rf *
        )

# make run
add_custom_target(run
        COMMAND ./${PROJECT_NAME}
        )

###################
## Download files
if(DOWNLOAD)
    include(cmake-modules/dl_vino_model.cmake)
    if(OPENVINO2019)
        dl_vino_model( "README.txt"                              "789e144d6cafa379c8437d2a6860829b6d935a8d" )
        dl_vino_model( "face-detection-adas-0001.bin"            "1625f05ada1d8e78e36856def7124f78cd0a6c2a" )
        dl_vino_model( "face-detection-adas-0001.xml"            "11c36f6e4488b2f5437ccff9f330d02545087ab3" )
        dl_vino_model( "age-gender-recognition-retail-0013.bin"  "206f6e97e53cd600fcac7d31e1c56accbbe461b9" )
        dl_vino_model( "age-gender-recognition-retail-0013.xml"  "2654d7f1638d575b8d1886f8128deae2ea79ee55" )
    else()
        # Newer model files with IRv10, 2020.1 and later
        dl_vino_model( "README.txt"                              "789e144d6cafa379c8437d2a6860829b6d935a8d" )
        dl_vino_model( "face-detection-adas-0001.bin"  "065e9015297c7adbc650ebfc17176477cd0a4279" )
        dl_vino_model( "face-detection-adas-0001.xml"  "331be642a248213f586ec1d1b71c223435a437e3" )
        dl_vino_model( "age-gender-recognition-retail-0013.bin"  "206f6e97e53cd600fcac7d31e1c56accbbe461b9" )
        dl_vino_model( "age-gender-recognition-retail-0013.xml"  "36bde5d4d42d29515abe871f69097ffcf4ff6414" )
    endif()
endif()
message(STATUS CMakeLists.txt[finish] ----------------------)