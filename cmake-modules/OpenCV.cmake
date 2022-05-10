#
# AVAILABLE VARIABLES
# set (OpenCV_LIBS)                # found libraries
# set (OpenCV_COMPONENTS_REQUIRED) # requested components
# set (OpenCV_LIB_COMPONENTS)      # found components
# set (OpenCV_VERSION)             # found version
message(STATUS OpenCV.cmake[start] ----------------------)
# -I <> -l <>
set(OpenCV_DIR /usr/include/opencv4)
# similar to: OpenCV=`pkg-config --cflags --libs opencv4`
find_package(OpenCV 4
        #        EXACT
        REQUIRED
        COMPONENTS
        opencv_core
        opencv_highgui
        CONFIG
        )

message(STATUS
        "OpenCV_VERSION=(${OpenCV_VERSION})
        OpenCV_COMPONENTS_REQUIRED=(${OpenCV_COMPONENTS_REQUIRED})
        OpenCV_LIB_COMPONENTS=(${OpenCV_LIB_COMPONENTS})"
        )
message(STATUS OpenCV.cmake[finish] ----------------------)