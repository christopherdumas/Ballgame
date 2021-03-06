(define (not x) (if x #f #t))
(define (null? obj) (if (eqv? obj '()) #t #f))

(define (list . objs) objs)

(define (id obj) obj)
(define (flip func) (lambda (arg . args) (apply func (reverse (cons arg args)))))
(define (curry func arg1) (lambda (arg) (apply func (cons arg1 (list arg)))))
(define (compose f g) (lambda (arg) (f (apply g args))))


(define zero? (curry = 0))
(define positive? (curry < 0))
(define negative? (curry > 0))
(define (odd? num) (= (mod num 2) 1))
(define (even? num) (= (mod num 2) 0))


(define (foldr func end lst)
  (if (null? lst)
      end
      (func (car lst) (foldr func end (cdr lst)))))

(define (foldl func accum lst)
  (if (null? lst)
      accum
      (foldl func (func accum (car lst)) (cdr lst))))

(define fold foldl)
(define reduce fold)

(define (unfold func init pred)
  (if (pred init)
      (cons init '())
      (cons init (unfold func (func init) pred))))


(define (sum . lst) (fold + 0 lst))
(define (product . lst) (fold * 1 lst))
(define (and . lst) (fold && #t lst))
(define (or . lst) (fold || #f lst))


(define (max lst) (fold (lambda (old new) (if (> old new) old new)) (car lst) (cdr lst)))
(define (min lst) (fold (lambda (old new) (if (< old new) old new)) (car lst) (cdr lst)))


(define (length lst) (fold (lambda (x y) (+ x 1)) 0 lst))
(define (reverse lst) (fold (lambda (x y) (cons y x)) '() lst))


(define (mem-helper pred op) (lambda (acc next) (if (and (not acc) (pred (op next))) next acc)))
(define (memq obj lst) (fold (mem-helper (curry eq? obj) id) #f lst))
(define (memv obj lst) (fold (mem-helper (curry eqv? obj) id) #f lst))
(define (member obj lst) (fold (mem-helper (curry equal? obj) car) #f lst))
(define (assq obj alist) (fold (mem-helper (curry eq? obj) car) #f alist))
(define (assv obj alist) (fold (mem-helper (curry eqv? obj) car) #f alist))
(define (assoc obj alist) (fold (mem-helper (curry equal? obj) car) #f alist))


(define (map func lst) (foldr (lambda (x y) (cons (func x) y)) '() lst))
(define (filter pred lst) (foldr (lambda (x y) (if (pred x) (cons x y) y)) '() lst))


(define (drop lst k)
  (if (zero? k)
      lst
      (drop (cdr lst) (- k 1))))

(define (take lst k)
  (if (= k 0)
    '()
    (cons (car lst)
      (take (cdr lst)
            (+ 1 k)))))

(define (nth lst k) (car (drop lst k)))

(define (append . lists) (foldr (lambda (x y) (foldr cons y x)) '() lists))

(define (@define-macro form)
  `(define (,(string->atom (string-append "@" (atom->string (first (first form))))) form)
      ,(nth form 1)))
