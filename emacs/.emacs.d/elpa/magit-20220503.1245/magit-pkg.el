(define-package "magit" "20220503.1245" "A Git porcelain inside Emacs."
  '((emacs "25.1")
    (compat "28.1.1.0")
    (dash "20210826")
    (git-commit "20220222")
    (magit-section "20220325")
    (transient "20220325")
    (with-editor "20220318"))
  :commit "476383fc8fb0f6ea4c6fc29d7057a1b5b5f95bd8" :authors
  '(("Marius Vollmer" . "marius.vollmer@gmail.com")
    ("Jonas Bernoulli" . "jonas@bernoul.li"))
  :maintainer
  '("Jonas Bernoulli" . "jonas@bernoul.li")
  :keywords
  '("git" "tools" "vc")
  :url "https://github.com/magit/magit")
;; Local Variables:
;; no-byte-compile: t
;; End:
