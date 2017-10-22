cmake_minimum_required( VERSION 3.0 )

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake )

project( unitsys )

find_package( Qt5 COMPONENTS Core Gui Widgets Qml Quick QuickControls2 Sql)
include_directories(${Qt5Core_INCLUDE_DIRS})


set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)


set( SOURCES ${SOURCES} src/main.cpp )

#set( HEADERS ${HEADERS} src/DbMovie.h )
#set( SOURCES ${SOURCES} src/DbMovie.cpp )

set( HEADERS ${HEADERS} src/MoviesModel.h )
set( SOURCES ${SOURCES} src/MoviesModel.cpp )

set( HEADERS ${HEADERS} src/MoviesModelHelp.h )

#odb_wrap( ODB_SOURCES ODB_HEADERS sqlite qt DbMovie src/DbMovie.h)
include_directories( ./src )

qt5_add_resources( RESOURCES resources.qrc )

add_executable( ${PROJECT_NAME} ${SOURCES} ${HEADERS} ${MOC_SOURCES} ${ODB_SOURCES} ${ODB_HEADERS} ${RESOURCES} main.rc )

target_link_libraries( ${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Widgets Qt5::Gui Qt5::Qml Qt5::Quick Qt5::Sql Qt5::QuickControls2 )

install(TARGETS ${PROJECT_NAME} DESTINATION . )
