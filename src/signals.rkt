#lang racket/base
;; Watching for control signals from the outside (Unix) environment

(provide poll-signal
	 start-restart-signal-watcher)

(require reloadable)

(define (poll-signal signal-file-name message handler)
  (when (file-exists? signal-file-name)
    (log-info message)
    (delete-file signal-file-name)
    (handler)))

(define (start-restart-signal-watcher)
  (thread
   (lambda ()
     (let loop ()
       (flush-output) ;; Somewhat gratuitous; help ensure timely stdout logging
       (poll-signal "../signals/.pull"
		    "Pull signal received"
		    (lambda ()
		      (local-require racket/system)
		      (system "git pull")
		      (exit 0)))
       (poll-signal "../signals/.restart"
		    "Restart signal received - attempting to restart"
		    (lambda () (exit 0)))
       (poll-signal "../signals/.reload"
                    "Reload signal received - attempting to reload code"
                    reload!)
       (sleep 0.5)
       (loop)))))
