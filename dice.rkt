#lang racket

(define (poly-min p)
    (argmin values (hash-keys p)))

(define (poly-deg p)
    (argmax values (hash-keys p)))

(define (poly-range p)
    (in-range (poly-min p) (+ 1 (poly-deg p))))

(define (poly-mul p1 p2)
    (for*/fold ([noob (hash)]) ([ i (poly-range p1)] [ j (poly-range p2)])
	(define k (+ i j))
	(define a (* (hash-ref p1 i) (hash-ref p2 j)))
	(hash-set noob k (+ (hash-ref noob k 0) a))))

(define (mega-mul ps)
    (foldl poly-mul (car ps) (cdr ps)))

(define (mkdie d)
    (make-immutable-hash
	(for*/list ([i (in-range 1 (+ 1 d))] [j (in-value 1)])
	    (cons i j))))

(define (mkroll r)
    (define n (car r))
    (define d (cdr r))
    (cons (mkdie d)
	(cond
	    [(equal? n 1) empty]
	    [else (mkroll (cons (- n 1) d))])))

(define (push xs x)
    (append xs (list x)))

(define (cool-round x y)
    (define scalar (expt 10 y))
    (/ (round (* x scalar)) scalar))

(define (mkhg x)
    (make-string (inexact->exact (round (* 500 x))) #\#))


; input

(define (args)
    (define yarr
	(vector->list
	    (current-command-line-arguments)))
    (for/fold
	([yash '(() . 0)])
	([arg yarr])
	(cond
	    [(regexp-match #rx"d" arg)
		(cons
		    (push (car yash)
			(let ([y (regexp-split #rx"d" arg)])
			    (cons (string->number (car y)) (string->number (cadr y)))))
		    (cdr yash))]
	    [else
		(cons
		    (car yash)
		    (+ (cdr yash) (string->number arg)))])))

(define input (args))
(define rolls (car input))
(define addme (cdr input))
(define combinations
    (foldl 
	(λ (x sum) (* sum (expt (cdr x) (car x))))
	1.0
	rolls))

(define polys
    (for/fold
	([ls '()])
	([r rolls])
	(append (mkroll r) ls)))

(define dist
    (hash-map
	(mega-mul polys)
	(λ (k v)
	    (cons
		(+ k addme)
		(cool-round (/ v combinations) 5)))))

(define output
    (string-join
	(map
	    (λ (term)
		(let ([x (car term)] [px (cdr term)])
		    (if (> px 0)
			(format "~a\t\t~a\t\t~a\n" x px (mkhg px))
			"")))
	    (sort dist (λ (a b) (< (car a) (car b)))))
	""))

(newline)
(display output)
(newline)

