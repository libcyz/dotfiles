;;; .emacs --- 入口 -*- lexical-binding: t -*-

(setq custom-file "~/.emacs.d/custom.el")

;; 后台把包编译成机器码时，包作者代码里的小毛病会弹警告窗口；不影响使用，不弹
(setq native-comp-async-report-warnings-errors 'silent)

(load "~/.emacs.rc/rc.el")
(load "~/.emacs.rc/misc-rc.el")

;;; Appearance
;; 打开时的窗口大小：宽 160 列，高 55 行
(add-to-list 'default-frame-alist '(width . 160))
(add-to-list 'default-frame-alist '(height . 55))

;; 没有图形支持的 Emacs（比如服务器上 --without-x 编译的）没有这两个函数
(when (fboundp 'tool-bar-mode) (tool-bar-mode 0))
(menu-bar-mode 0)
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode 0))
(column-number-mode 1)
(show-paren-mode 1)

(set-face-attribute 'default nil :height 120)

;;用 y/n 回答，递归删除不再需要一个一个确认
(setq dired-deletion-confirmer #'y-or-n-p)
(setq dired-recursive-deletes 'always)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(rc/require-theme 'gruber-darker)

(rc/require 'smart-mode-line)
(setq sml/no-confirm-load-theme t
      sml/theme 'respectful)
(sml/setup)

(load "~/.emacs.rc/dashboard-rc.el")

;;; Indentation
;; 缩进用 Tab，一个 Tab 显示为 4 列宽
(setq-default indent-tabs-mode t
              tab-width 4)
(setq-default c-basic-offset 4)
(setq c-ts-mode-indent-offset 4)
;; C 的大括号风格：默认 gnu 会把单独一行的 { 再缩进一级，换成 bsd
(setq c-ts-mode-indent-style 'bsd)

;;; tree-sitter：语法高亮改用 *-ts-mode（Emacs 支持 tree-sitter 且 grammar 装了才切换）

(setq treesit-font-lock-level 3)

(dolist (remap '((c . ((c-mode . c-ts-mode)
                       (c-or-c++-mode . c-or-c++-ts-mode)))
                 (cpp . ((c++-mode . c++-ts-mode)))
                 (python . ((python-mode . python-ts-mode)))
                 (rust . ((rust-mode . rust-ts-mode)))))
  (when (and (fboundp 'treesit-language-available-p)
             (treesit-language-available-p (car remap)))
    (dolist (pair (cdr remap))
      (add-to-list 'major-mode-remap-alist pair))))

;;; Editing
(rc/require 'drag-stuff)
(global-set-key (kbd "<M-up>")   'drag-stuff-up)
(global-set-key (kbd "<M-down>") 'drag-stuff-down)

;;; multiple cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;;; windmove：Shift+方向键切换窗口
(windmove-default-keybindings)

;;; dired
;; 开两个 dired 窗口时，复制/移动的目标默认填另一个窗口的目录
(setq-default dired-dwim-target t)
;; 显示隐藏文件，大小用 K/M/G
(setq dired-listing-switches "-alh")

;;; savehist：记住 M-x 历史，常用命令排在前面
(savehist-mode 1)

;;; ido：M-x、C-x C-f、C-x b 等补全，候选横排显示，C-s / C-r 切换
(rc/require 'ido-completing-read+)
(require 'ido-completing-read+)

;; 模糊匹配：输入 gtr 就能匹配 gt-translate
(setq ido-enable-flex-matching t)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)   ; 让 M-x 和其它用 completing-read 的地方也走 ido

;;; Company
(rc/require 'company)
(require 'company)

(setq company-minimum-prefix-length 1
      company-idle-delay 0.1
      company-tooltip-align-annotations t
      company-selection-wrap-around t
      company-show-quick-access t)
(global-company-mode 1)

(define-key company-active-map (kbd "C-n")   'company-select-next)
(define-key company-active-map (kbd "C-p")   'company-select-previous)
(define-key company-active-map (kbd "<tab>") 'company-complete-selection)
(define-key company-active-map (kbd "TAB")   'company-complete-selection)

;;; Flycheck：诊断（错误/警告），lsp-mode 会自动对接
(rc/require 'flycheck)
(require 'flycheck)

;;; Rust 主模式（C / Python 用 Emacs 内置的）
(rc/require 'rust-mode)

;;; LSP：打开 Rust / Python 文件后自动启动对应语言服务器
;; C / C++ 不用：clangd 会在输入时改格式，写 C 不习惯
(rc/require 'lsp-mode 'lsp-ui 'yasnippet)

;; 前缀必须在加载 lsp-mode 之前设置
(setq lsp-keymap-prefix "C-c l")
(require 'lsp-mode)
(require 'yasnippet)

(setq lsp-idle-delay 0.1
      lsp-auto-guess-root t
      lsp-keep-workspace-alive nil
      lsp-inlay-hint-enable t
      ;; 关掉已过时的 Python 服务器，优先用 pylsp
      lsp-disabled-clients '(pyls mspyls)
      ;; Rust：rust-analyzer
      lsp-rust-analyzer-cargo-watch-command "clippy"
      lsp-rust-analyzer-display-chaining-hints t
      lsp-rust-analyzer-display-closure-return-type-hints t)

(dolist (hook '(rust-mode-hook rust-ts-mode-hook
                python-mode-hook python-ts-mode-hook))
  (add-hook hook #'lsp-deferred))

(add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
;; 代码片段：rust-analyzer 的重构/补全需要 yasnippet
(add-hook 'lsp-mode-hook #'yas-minor-mode)

;; 格式只交给一方管：打字时用编辑模式自己的缩进，LSP 不插手
(setq lsp-enable-on-type-formatting nil   ; 输入 ; } 回车后不自动改格式
      lsp-enable-indentation nil)         ; 缩进选区时不交给 LSP

;;; apheleia：保存时用格式化工具整理整个文件，光标不乱跳
;; Rust 用 rustfmt；Python 装了 ruff 才开；C 先不开（需要项目里有 .clang-format）
(rc/require 'apheleia)
(require 'apheleia)

(setf (alist-get 'python-mode apheleia-mode-alist) 'ruff
      (alist-get 'python-ts-mode apheleia-mode-alist) 'ruff)

(add-hook 'rust-mode-hook #'apheleia-mode)
(add-hook 'rust-ts-mode-hook #'apheleia-mode)
(when (executable-find "ruff")
  (add-hook 'python-mode-hook #'apheleia-mode)
  (add-hook 'python-ts-mode-hook #'apheleia-mode))

;;; magit：C-x g 打开状态窗口
(rc/require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;;; 翻译：选中英文后按 C-c t，译文在侧边窗口显示（没有选中时翻译光标处的单词）
(rc/require 'gt)
(require 'gt)

(setq gt-langs '(en zh)
      gt-default-translator
      (gt-translator :engines (gt-bing-engine)
                     :render (gt-buffer-render)))
(global-set-key (kbd "C-c t") 'gt-translate)

;;; nov：用 C-x C-f 打开 .epub 就进入阅读模式
(rc/require 'nov)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; 每行最多 80 个字符，太宽了读着累
(setq nov-text-width 80)
;; 阅读时不要行号
(add-hook 'nov-mode-hook (lambda () (display-line-numbers-mode -1)))

;;; Markdown：在 Emacs 里直接读，隐藏 ** ` 链接地址等符号，标题放大，图片直接显示
;; C-c C-x C-m 切换显示/隐藏符号，C-c C-x C-i 切换图片
(rc/require 'markdown-mode)
(setq-default markdown-hide-markup t)          ; 每个 buffer 各一份，要用 setq-default
(setq markdown-header-scaling t
      markdown-fontify-code-blocks-natively t)   ; 代码块按对应语言高亮
(add-hook 'markdown-mode-hook #'markdown-display-inline-images)

;; 表格按像素对齐（中英混排也齐），竖线和分隔行画成细线
(rc/require 'valign)
(setq valign-fancy-bar t)
(add-hook 'markdown-mode-hook #'valign-mode)
(add-hook 'org-mode-hook #'valign-mode)

;;; vterm：Windows 上用不了
(unless (eq system-type 'windows-nt)
  (load "~/.emacs.rc/vterm-rc.el"))

(when (file-exists-p custom-file)
  (load custom-file nil t))
