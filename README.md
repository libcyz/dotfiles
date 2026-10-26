# dotfiles

我的 Emacs 配置，参考 [rexim/dotfiles](https://github.com/rexim/dotfiles)：不用 use-package，缺什么包启动时自动安装，全部一次加载。

## 安装

需要 Emacs 30 以上。

```bash
git clone <这个仓库> ~/dotfiles
cd ~/dotfiles
./deploy.sh        # Linux / macOS；Windows 用 .\deploy.ps1
```

打开 Emacs，第一次启动会自动装包，等它装完即可。

如果脚本提示某个文件已存在，说明根目录里已经有旧的 `.emacs` 等文件，移除再运行一次。Windows 上创建软链接需要管理员权限，或者打开"开发人员模式"。

