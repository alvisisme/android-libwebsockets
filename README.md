# libwebsockets-for-android

[![Build Status](https://img.shields.io/travis/com/alvisisme/android-libwebsockets?style=flat-square)](https://travis-ci.com/alvisisme/android-libwebsockets)

编译libwebsockets至android平台arm64-v8a架构。

本工程编译包含静态库和动态库。

## 目录

- [背景](#背景)
- [安装](#安装)
- [用法](#用法)
- [维护人员](#维护人员)
- [贡献参与](#贡献参与)
- [许可](#许可)

## 背景

编译环境

* Ubuntu 18.04.4 LTS amd64
* android-ndk-r13b
* libwebsockets v3.0.0

## 安装

将**dist**目录下对应头文件和静态库/动态库引入。

## 用法

推荐使用 docker 和 docker-compose 进行编译

```bash
docker-compose up --build
```

编译后的静态库和动态库位于 **build/lib** 目录下。

注意事项：

Android平台不支持带版本号的so库,需要改动CMakeLists.txt,主要将CMakeLists.txt的如下语句注释

  ```CMake
  if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR (CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
    foreach(lib ${LWS_LIBRARIES})
      set_target_properties(${lib}
        PROPERTIES
        SOVERSION ${SOVERSION})
    endforeach()
  endif()
  ```

## 维护人员

[@Alvis Zhao](https://github.com/alvisisme)

## 贡献参与

欢迎提交PR。

## 许可

© 2020 Alvis Zhao
