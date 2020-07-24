cmake_minimum_required(VERSION 2.8)
# set(CMAKE_VERBOSE_MAKEFILE 1)

find_package(Boost COMPONENTS python-py35 REQUIRED) # for python3
find_package(PythonLibs REQUIRED)
include_directories(${Boost_INCLUDE_DIRS} ${PYTHON_INCLUDE_DIRS})

add_library(simple3 SHARED simple3.cpp)
target_link_libraries(simple3 ${Boost_LIBRARIES} ${PYTHON_LIBRARY} boost_python)
set_target_properties(simple3 PROPERTIES PREFIX "") # 接頭辞'lib'を省略するため
