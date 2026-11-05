;;; early-init.el --- 第一帧创建前的设置 -*- lexical-binding: t -*-

(setenv "GTK_THEME" "Adwaita:dark")

;; Emacs 31 起，加载没写 lexical-binding 声明的 .el 会弹警告；包和系统文件里的不归我改，不弹
(setq warning-suppress-log-types '((files missing-lexbind-cookie)))
