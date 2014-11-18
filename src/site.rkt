#lang racket/base

(provide request-handler)

(require racket/match)
(require racket/date)
(require web-server/servlet)
(require reloadable)

(require "config.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Persistent state:

(define counter (make-persistent-state 'counter (lambda () 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Transient state:

(define reload-date (current-date))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-values (request-handler named-url)
  (dispatch-rules
   [("index") main-page]
   [("") main-page]
   [("changecounter") #:method "post" change-counter-page]
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (respond xexpr)
  (response/xexpr
   #:preamble #"<!DOCTYPE html>\n"
   `(html
     (head (meta ((charset "utf-8")))
	   (title "Example Reloadable Racket Website")
           (link ((rel "stylesheet") (href "/style.css") (type "text/css"))))
     (body ,xexpr))))

(define (main-page req)
  (respond `(div
             (h1 "Example Reloadable Racket Website")
             (p ,configurable-text)
             (p "The counter's current value is "
                ,(number->string (counter))
                ".")
             (p "The last reload happened at "
                ,(date->string reload-date #t)
                ".")
             (hr)
             (form ((id "counter-form")
                    (method "post")
                    (action ,(named-url change-counter-page)))
                   (button ((type "submit")
                            (name "action")
                            (value "increment"))
                           "Increment counter")
                   (button ((type "submit")
                            (name "action")
                            (value "decrement"))
                           "Decrement counter")))))

(define (change-counter-page req)
  (match (extract-binding/single 'action (request-bindings req))
    ["increment"
     (counter (+ (counter) 1))]
    ["decrement"
     (counter (- (counter) 1))]
    [_
     (void)])
  (redirect-to (named-url main-page)))
