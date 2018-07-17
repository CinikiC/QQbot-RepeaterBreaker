# 基于Psake进行自动化构建脚本框架

本框架采用Psake作为脚本构建框架，依托Powershell本身强大的功能，实现对开发过程自动化的功能。

## 基本步骤

1. 使用powershell进入你的项目根文件夹。

1. 在powershell中执行以下命令。

  ```cmd
  (curl http://www.newbe.pro/assets/others/scripts/newbe.build.psake.install.txt).Content | powershell
  ```

1. 安装过程需要从互联网下载相关的组件，等待下载完毕即可。

1. 按照psake规范对build.ps1进行修改

1. 执行build.bat便可以执行
