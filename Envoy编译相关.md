使用官方提供的包含Bazel工具的镜像进行打包即可。



- 修改docker的临时文件目录，避免根目录的挂载盘存储空间不足：`export ENVOY_DOCKER_BUILD_DIR=/home/lijiancai/envoy-docker-build`
- 设置环境变量BUILD_WITH_CONTAINER，使用容器编译：`export BUILD_WITH_CONTAINER=1`
- 

