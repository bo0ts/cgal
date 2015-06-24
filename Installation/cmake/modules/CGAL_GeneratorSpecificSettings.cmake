if ( NOT CGAL_GENERATOR_SPECIFIC_SETTINGS_FILE_INCLUDED )
  set( CGAL_GENERATOR_SPECIFIC_SETTINGS_FILE_INCLUDED 1 )

  message( STATUS "Targetting ${CMAKE_GENERATOR}")

  if ( MSVC )
    message( STATUS "Target build enviroment supports auto-linking" )
    set(CGAL_AUTO_LINK_ENABLED TRUE)
  endif()

  # From james Bigler, in the cmake users list.
  IF (APPLE)
    exec_program(uname ARGS -v  OUTPUT_VARIABLE DARWIN_VERSION)
    string(REGEX MATCH "[0-9]+" DARWIN_VERSION ${DARWIN_VERSION})
    message(STATUS "DARWIN_VERSION=${DARWIN_VERSION}")
    if (DARWIN_VERSION GREATER 8)
       message(STATUS "Mac Leopard detected")
      set(CGAL_APPLE_LEOPARD 1)
    endif()
  endif()

  if ( NOT "${CMAKE_CFG_INTDIR}" STREQUAL "." )
    set(HAS_CFG_INTDIR TRUE CACHE INTERNAL "Generator uses intermediate configuration directory" )
    message( STATUS "Generator uses intermediate configuration directory: ${CMAKE_CFG_INTDIR}" )
  endif()

endif()
