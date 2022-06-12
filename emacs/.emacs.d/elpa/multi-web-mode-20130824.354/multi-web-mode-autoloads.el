;;; multi-web-mode-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "multi-web-mode" "multi-web-mode.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from multi-web-mode.el

(autoload 'multi-web-mode "multi-web-mode" "\
Enables the multi web mode chunk detection and indentation

This is a minor mode.  If called interactively, toggle the
`Multi-Web mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `multi-web-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(put 'multi-web-global-mode 'globalized-minor-mode t)

(defvar multi-web-global-mode nil "\
Non-nil if Multi-Web-Global mode is enabled.
See the `multi-web-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `multi-web-global-mode'.")

(custom-autoload 'multi-web-global-mode "multi-web-mode" nil)

(autoload 'multi-web-global-mode "multi-web-mode" "\
Toggle Multi-Web mode in all buffers.
With prefix ARG, enable Multi-Web-Global mode if ARG is positive; otherwise,
disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Multi-Web mode is enabled in all buffers where `multi-web-mode-maybe' would do
it.

See `multi-web-mode' for more information on Multi-Web mode.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "multi-web-mode" '("multi-web-mode-maybe" "mweb-"))

;;;***

;;;### (autoloads nil nil ("multi-web-mode-pkg.el" "mweb-example-config.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; multi-web-mode-autoloads.el ends here
