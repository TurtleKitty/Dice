#lang racket

(define (poly-deg p)
    (vector-length p))

(define (poly-mul p1 p2)
    (define deg1 (poly-deg p1))
    (define deg2 (poly-deg p2))
    (for*/fold ([noob (make-vector (- (+ deg1 deg2) 1))])
	([ i (in-range 1 deg1)]
	 [ j (in-range 1 deg2)])
	(begin
	    (vector-set!
		noob (+ i j)
		(+  (vector-ref noob (+ i j))
		    (* (vector-ref p1 i) (vector-ref p2 j))))
	    noob)))

(define (mega-mul ps)
    (foldl poly-mul (car ps) (cdr ps)))

(define (mkdie d)
    (make-vector (+ 1 d) 1))

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
    (vector-map
	(λ (x) (cool-round (/ x combinations) 5))
	(mega-mul
	    (for/fold
		([ls '()])
		([r rolls])
		(append (mkroll r) ls)))))

(newline)
(for ([i (in-range 0 (vector-length dist))])
    (if (> (vector-ref dist i) 0)
	(displayln (format "~a~a~a" (+ i addme) #\tab (vector-ref dist i)))
	""))
(newline)

