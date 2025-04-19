find_package(CURL REQUIRED)

add_library(CURL INTERFACE)

target_link_libraries(CURL
        INTERFACE
        curl::libcurl)
