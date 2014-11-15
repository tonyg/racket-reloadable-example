#lang racket/base

(require web-server/servlet-env)
(require reloadable)
(require "signals.rkt")

(define (main)
  (define request-handler
    (reloadable-entry-point->procedure
     (make-reloadable-entry-point 'request-handler "site.rkt")))

  (when (not (getenv "SITE_RELOADABLE"))
    (set-reload-poll-interval! #f))

  (reload!)

  (start-restart-signal-watcher)
  (serve/servlet request-handler
                 #:launch-browser? #f
                 #:quit? #f
                 #:listen-ip #f
                 #:port 8765
                 #:extra-files-paths (list (build-path (current-directory) "../static"))
                 #:servlet-regexp #rx""))

(main)
