;;; init.el --- Emacs Initialization -*- lexical-binding: t; -*-

;;; Time the startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Loaded Emacs in %.03fs"
                     (float-time (time-subtract after-init-time before-init-time)))))

;;; Temporarily reduce garbage collection to gain some performance boost.
(eval-when-compile
  (let ((normal-gc-cons-threshold 800000)
	(normal-gc-cons-percentage 0.1)
	(normal-file-name-handler-alist file-name-handler-alist)
	(init-gc-cons-threshold 402653184)
	(init-gc-cons-percentage 0.6))
    (setq gc-cons-threshold init-gc-cons-threshold
          gc-cons-percentage init-gc-cons-percentage
          file-name-handler-alist nil)
    (add-hook 'after-init-hook
              `(lambda ()
		 (setq gc-cons-threshold ,normal-gc-cons-threshold
                       gc-cons-percentage ,normal-gc-cons-percentage
                       file-name-handler-alist ',normal-file-name-handler-alist)))))

;; Disable GUI components
(when window-system
  (setq use-dialog-box nil)
  (menu-bar-mode 0)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (tooltip-mode 0))

;; Require `use-package' to help with byte-compile checks
(eval-when-compile
  (when (locate-library "use-package")
    (require 'use-package)))

(load-file (expand-file-name "config.el" user-emacs-directory))
;;; init.el ends here
