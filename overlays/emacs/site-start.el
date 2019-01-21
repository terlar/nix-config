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


(defun nix--profile-paths ()
  "Returns a list of all paths in the NIX_PROFILES environment
variable, ordered from more-specific (the user profile) to the
least specific (the system profile)"
  (reverse (split-string (or (getenv "NIX_PROFILES") ""))))

;;; Extend `load-path' to search for elisp files in subdirectories of
;;; all folders in `NIX_PROFILES'. Also search for one level of
;;; subdirectories in these directories to handle multi-file libraries
;;; like `mu4e'.'
(require 'seq)
(let* ((subdirectory-sites (lambda (site-lisp)
                             (when (file-exists-p site-lisp)
                               (seq-filter (lambda (f) (file-directory-p (file-truename f)))
                                           ;; Returns all files in `site-lisp', excluding `.' and `..'
                                           (directory-files site-lisp 'full "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)")))))
       (paths (apply #'append
                     (mapcar (lambda (profile-dir)
                               (let ((site-lisp (concat profile-dir "/share/emacs/site-lisp/")))
                                 (cons site-lisp (funcall subdirectory-sites site-lisp))))
                             (nix--profile-paths)))))
  (setq load-path (append paths load-path)))


;;; Make `woman' find the man pages
(eval-after-load 'woman
  '(setq woman-manpath
         (append (mapcar (lambda (x) (concat x "/share/man/"))
                         (nix--profile-paths))
                 woman-manpath)))

;;; Make tramp work for remote NixOS machines
(eval-after-load 'tramp
  ;; TODO: We should also add the other `NIX_PROFILES' to this path.
  ;; However, these are user-specific, so we would need to discover
  ;; them dynamically after connecting via `tramp'
  '(add-to-list 'tramp-remote-path "/run/current-system/sw/bin"))

;;; C source directory
;;;
;;; Computes the location of the C source directory from the path of
;;; the current file:
;;; from: /nix/store/<hash>-emacs-<version>/share/emacs/site-lisp/site-start.el
;;; to:   /nix/store/<hash>-emacs-<version>/share/emacs/<version>/src/
(let ((emacs
       (file-name-directory                      ; .../emacs/
        (directory-file-name                     ; .../emacs/site-lisp
         (file-name-directory load-file-name)))) ; .../emacs/site-lisp/
      (version
       (file-name-as-directory
        (concat
         (number-to-string emacs-major-version)
         "."
         (number-to-string emacs-minor-version))))
      (src (file-name-as-directory "src")))
  (setq find-function-C-source-directory (concat emacs version src)))


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
