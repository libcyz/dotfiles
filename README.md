# dotfiles

我的 Emacs 配置，参考 [rexim/dotfiles](https://github.com/rexim/dotfiles)：不用 use-package，缺什么包启动时自动安装，全部一次加载。

## 文件结构

主配置是 `.emacs`，外观、编辑习惯和各个包都在里面。`.emacs.rc/` 放拆出去的部分：`rc.el` 是装包用的 `rc/require` 函数和软件源，`misc-rc.el` 管编码、PATH、Linux 剪贴板和 macOS 适配，`dashboard-rc.el` 是启动首页，`keys.org` 是快捷键文档。`MANIFEST` 写明哪些文件要链接到家目录，`deploy.sh` 和 `deploy.ps1` 按它去链接。

## 安装

需要 Emacs 30 以上。

```bash
git clone <这个仓库> ~/dotfiles
cd ~/dotfiles
./deploy.sh        # Linux / macOS；Windows 用 .\deploy.ps1
```

打开 Emacs，第一次启动会自动装包，等它装完即可。

如果脚本提示某个文件已存在，说明家目录里已经有旧的 `.emacs` 等文件，挪走再运行一次。Windows 上创建软链接需要管理员权限，或者打开"开发人员模式"。

