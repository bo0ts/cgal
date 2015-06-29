include(CGAL_Macros)

if(RUNNING_CGAL_AUTO_TEST)
# Just to avoid a warning from CMake if that variable is set on the command line...
endif()

# Common settings for CGAL cmake scripts
if( NOT CGAL_COMMON_FILE_INCLUDED )
  set(CGAL_COMMON_FILE_INCLUDED 1 )

  # CMAKE_ROOT must be properly configured, but is not by the CMake windows installer, so check here
  if (NOT CMAKE_ROOT)
    message( FATAL_ERROR "CMAKE_ROOT environment variable not set. It should point to the directory where CMake is installed.")
  endif()

  if ( CGAL_BUILDING_LIBS )
    option(BUILD_SHARED_LIBS "Build shared libraries" ON)
    set(CGAL_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})

    if ( BUILD_SHARED_LIBS )
      message( STATUS "Building shared libraries" )
    else()
      message( STATUS "Building static libraries" )
    endif()
  endif()
endif()
