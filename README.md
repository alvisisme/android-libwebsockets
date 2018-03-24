# build libwebsockets for android

编译libwebsockets到Android平台,arm64架构。

## 编译环境

* Ubuntu 16.04.4 LTS
* Docker version 17.12.1-ce, build 7390fc6

## 编译步骤

  ```shell
  make
  ```

## 相关源码和工具

* android-ndk-r13b
* libwebsockets v2.4.1

## 注意事项

* Android平台不支持带版本号的so库,需要改动CMakeLists.txt,脚本通过补丁方式修改原始CMakeLists.txt

  主要将CMakeLists.txt的如下语句注释

  ```CMake
  if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR (CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
    foreach(lib ${LWS_LIBRARIES})
      set_target_properties(${lib}
        PROPERTIES
        SOVERSION ${SOVERSION})
    endforeach()
  endif()
  ```

## 辅助工程

* [openssl for android](https://github.com/alvisisme/android-openssl)
* [libuv for android](https://github.com/alvisisme/android-libuv)
