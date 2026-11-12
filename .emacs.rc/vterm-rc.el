;;; vterm-rc.el --- 终端 -*- 

;; 编译需要 cmake、gcc 和 libvterm：sudo dnf install libvterm-devel
(setq vterm-always-compile-module t)

(rc/require 'vterm)

;; C-c v 打开终端
(global-set-key (kbd "C-c v") 'vterm)

;; 终端里不要行号
(add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode -1)))
