# build libwebsockets for android

编译libwebsockets到Android平台上,arm或者arm64架构。

## 编译环境

* Ubuntu16.04 64位
* android-ndk-r13b
* libwebsockets v2.3.0

## 编译步骤

* 修改**build.sh**设定NDK路径,默认为

    ```shell
    export NDK=/opt/android-ndk
    ```

* 执行**build.sh**脚本,根据提示选择编译架构

    ```shell
    bash build.sh
    ```
* 编译后头文件位于 **$ARCH/include**, 静态库位于 **$ARCH/lib**

## 注意事项

* Android平台不支持带版本号的so库,需要改动CMakeLists.txt,脚本通过补丁方式修改原始CMakeLists.txt

## 辅助工程

* [zlib for android](https://github.com/alvisisme/android-zlib)
* [openssl for android](https://github.com/alvisisme/android-openssl)
* [libuv for android](https://github.com/alvisisme/android-libuv)
