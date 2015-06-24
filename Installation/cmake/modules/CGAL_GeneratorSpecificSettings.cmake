if ( NOT CGAL_GENERATOR_SPECIFIC_SETTINGS_FILE_INCLUDED )
  set( CGAL_GENERATOR_SPECIFIC_SETTINGS_FILE_INCLUDED 1 )

  message( STATUS "Targetting ${CMAKE_GENERATOR}")

  if ( MSVC )
    message( STATUS "Target build enviroment supports auto-linking" )
    set(CGAL_AUTO_LINK_ENABLED TRUE)
  endif()

  if ( NOT "${CMAKE_CFG_INTDIR}" STREQUAL "." )
    set(HAS_CFG_INTDIR TRUE CACHE INTERNAL "Generator uses intermediate configuration directory" )
    message( STATUS "Generator uses intermediate configuration directory: ${CMAKE_CFG_INTDIR}" )
  endif()

endif()
