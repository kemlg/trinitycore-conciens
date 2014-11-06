# - Find Rabbitmqc
# Find the Rabbitmqc includes and client library
# This module defines
#  Rabbitmqc_INCLUDE_DIR, where to find mongo/client/dbclient.h
#  Rabbitmqc_LIBRARIES, the libraries needed to use Rabbitmqc.
#  Rabbitmqc_FOUND, If false, do not try to use Rabbitmqc.

if(Rabbitmqc_INCLUDE_DIR AND Rabbitmqc_LIBRARIES)
  set(Rabbitmqc_FOUND TRUE)

else(Rabbitmqc_INCLUDE_DIR AND Rabbitmqc_LIBRARIES)

  find_path(Rabbitmqc_INCLUDE_DIR amqp.h
    /usr/include/
    /usr/local/include/
    /opt/local/include/
    )

    find_library(Rabbitmqc_LIBRARIES NAMES rabbitmq
      PATHS
      /usr/lib
      /usr/local/lib
      /opt/local/lib
      )

  if(Rabbitmqc_INCLUDE_DIR AND Rabbitmqc_LIBRARIES)
    set(Rabbitmqc_FOUND TRUE)
    message(STATUS "Found Rabbitmqc: ${Rabbitmqc_INCLUDE_DIR}, ${Rabbitmqc_LIBRARIES}")
  else(Rabbitmqc_INCLUDE_DIR AND Rabbitmqc_LIBRARIES)
    set(Rabbitmqc_FOUND FALSE)
    if (Rabbitmqc_FIND_REQUIRED)
      message(FATAL_ERROR "Rabbitmqc not found.")
    else (Rabbitmqc_FIND_REQUIRED)
      message(STATUS "Rabbitmqc not found.")
    endif (Rabbitmqc_FIND_REQUIRED)
  endif(Rabbitmqc_INCLUDE_DIR AND Rabbitmqc_LIBRARIES)

  mark_as_advanced(Rabbitmqc_INCLUDE_DIR Rabbitmqc_LIBRARIES)

endif(Rabbitmqc_INCLUDE_DIR AND Rabbitmqc_LIBRARIES)
