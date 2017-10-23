cmake_minimum_required( VERSION 3.0 )

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake )

project( generate-mockup-data )

find_package( Qt5 COMPONENTS Core )
include_directories(${Qt5Core_INCLUDE_DIRS})

find_package( SQLite3 REQUIRED )
include_directories( ${SQLITE3_INCLUDE_DIR} )

find_package( ODB REQUIRED )
include_directories( ${ODB_INCLUDE_DIR} )
include_directories( ${ODB_QT_INCLUDE_DIR} )
include_directories( ${ODB_SQLITE_INCLUDE_DIR} )

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set( SOURCES ${SOURCES} main.cpp )

set( HEADERS ${HEADERS} DbMovie.h )
set( SOURCES ${SOURCES} DbMovie.cpp )

odb_wrap( ODB_SOURCES ODB_HEADERS sqlite qt DbMovie DbMovie.h)
include_directories( ./src )

add_executable( ${PROJECT_NAME} ${SOURCES} ${HEADERS} ${ODB_SOURCES} ${ODB_HEADERS} )

target_link_libraries( ${PROJECT_NAME} PRIVATE Qt5::Core )
target_link_libraries( ${PROJECT_NAME} PRIVATE ${ODB_LIBRARIES} )
target_link_libraries( ${PROJECT_NAME} PRIVATE ${ODB_QT_LIBRARY} )
target_link_libraries( ${PROJECT_NAME} PRIVATE ${ODB_SQLITE_LIBRARY} )
target_link_libraries( ${PROJECT_NAME} PRIVATE ${SQLITE3_LIBRARIES} )

install(TARGETS ${PROJECT_NAME} DESTINATION . )

