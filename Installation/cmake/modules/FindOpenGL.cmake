if ( NOT FIND_OPENGL_WRAPPER )

  set ( FIND_OPENGL_WRAPPER 1 )
  
  set(SAVED_CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} )
  
  set(CMAKE_MODULE_PATH ${ORIG_CMAKE_MODULE_PATH} )
  
  find_package(OpenGL)
  
  # From james Bigler, in the cmake users list.
  IF (APPLE)
    exec_program(uname ARGS -v  OUTPUT_VARIABLE DARWIN_VERSION)
    string(REGEX MATCH "[0-9]+" DARWIN_VERSION ${DARWIN_VERSION})
    message(STATUS "DARWIN_VERSION=${DARWIN_VERSION}")
    if (DARWIN_VERSION GREATER 8)
      message(STATUS "Mac Leopard detected")
      set(OPENGL_APPLE_LEOPARD 1)
    endif()
  endif()

  if ( OPENGL_FOUND AND OPENGL_APPLE_LEOPARD )
  
    if ( BUILD_SHARED_LIBS )
    
      uniquely_add_flags( CMAKE_SHARED_LINKER_FLAGS
                        "-Wl,-dylib_file,/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib:/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib"
                        )
                        
    else()
    
      uniquely_add_flags( CMAKE_MODULE_LINKER_FLAGS
                        "-Wl,-dylib_file,/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib:/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib"
                        )
    endif()
                      
                      
  endif()
  
  set(CMAKE_MODULE_PATH ${SAVED_CMAKE_MODULE_PATH} )

endif()
