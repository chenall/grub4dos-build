# grub4dos 专用编译脚本

 grub4dos 专用编译脚本，只用于编译 grub4dos。

# 使用方法
  一个简单的例子

```yml
  name: grub4dos 外部调用测试
on: 
  push:
   branches: [ "main" ]

jobs:

  build:
    name: build
    runs-on: ubuntu-18.04
    steps:
     - name: 下载 grub4dos efi 版最新源码
       uses: actions/checkout@v2
       with:
        repository: chenall/grub4dos
        ref: efi
     - name: 开始编译
       uses: chenall/grub4dos-build@main
```

# 调试方法
  
  配置变量 `DEBUG_ACTION` 为 `true` 或 即可开启调试功能。  
  开启调试功能后在开始和结束前都会调用 tmate 可以用 SSH 连接。
  

  