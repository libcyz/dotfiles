;;; vterm-rc.el --- 终端 -*- lexical-binding: t -*-

;; 编译需要 cmake、gcc 和 libvterm：sudo dnf install libvterm-devel
(setq vterm-always-compile-module t)

;; 终端里能往回翻的行数（默认 1000，最大 100000）
(setq vterm-max-scrollback 10000)

(rc/require 'vterm)

;; C-c v 打开终端
(global-set-key (kbd "C-c v") 'vterm)

;; 终端里不要行号
(add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode -1)))

(with-eval-after-load 'vterm
  ;; C-c 直接发给终端（退出 agent、中断命令），不再当 Emacs 前缀键
  (define-key vterm-mode-map (kbd "C-c") #'vterm--self-insert)

  ;; 复制模式（原来是 C-c C-t）：冻结屏幕，像普通 buffer 一样翻页、搜索、复制
  ;; 再按一次或按 RET 回到终端（RET 会顺便复制选中的内容）
  (define-key vterm-mode-map (kbd "C-x C-q") #'vterm-copy-mode)
  (define-key vterm-copy-mode-map (kbd "C-x C-q") #'vterm-copy-mode))
