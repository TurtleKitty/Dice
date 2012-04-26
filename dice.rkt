#lang racket

(define (poly-deg p)
    (cdr (argmax cdr p)))

(define (addterms p n)
    (foldl
	(λ (x acc)
	    (cons (+ (car x) (car acc)) (cdr acc)))
	(cons 0 n)
	(filter (λ (y) (equal? n (cdr y))) p)))

(define (poly-simp p)
    (define deg (poly-deg p))
    (filter (λ (x) (> (car x) 0))
	(for/list ([pow (in-range deg -1 -1)])
	    (addterms p pow))))

(define (poly-mul p1 p2)
    (for*/list ([x p1] [y p2])
	(cons
	    (* (car x) (car y))
	    (+ (cdr x) (cdr y)))))

(define (mega-mul ps)
    (foldl poly-mul (car ps) (cdr ps)))

(define (mkdie d)
    (for/list ([i (in-range 1 (+ 1 d))])
	(cons 1 i)))

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
	(λ (x sum) (+ sum (expt (cdr x) (car x))))
	0.0
	rolls))

(define dist
    (map
	(λ (x)
	    (cons
		(cool-round (/ (car x) combinations) 5)
		(cdr x)))
	(reverse
	    (map
		(λ (x) (cons (car x) (+ addme (cdr x))))
		(poly-simp
		    (mega-mul
			(for/fold
			    ([ls '()])
			    ([r rolls])
			    (append (mkroll r) ls))))))))

(newline)
(for ([i dist])
    (displayln (format "~a~a~a" (cdr i) #\tab (car i))))
(newline)

