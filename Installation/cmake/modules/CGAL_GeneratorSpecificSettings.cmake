if ( NOT CGAL_GENERATOR_SPECIFIC_SETTINGS_FILE_INCLUDED )
  set( CGAL_GENERATOR_SPECIFIC_SETTINGS_FILE_INCLUDED 1 )

  message( STATUS "Targetting ${CMAKE_GENERATOR}")

  if ( MSVC )
    message( STATUS "Target build enviroment supports auto-linking" )
    set(CGAL_AUTO_LINK_ENABLED TRUE)
  endif()

endif()
