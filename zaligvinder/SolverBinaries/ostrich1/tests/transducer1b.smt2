(set-logic QF_S)

; Successor transducer

(set-option :parse-transducers true)

(define-funs-rec ((succ ((x String) (y String)) Bool)
                  (succH ((x String) (y String)) Bool)) (
                  ; definition of succ
                  (or (and (not (= x "")) (not (= y ""))
                           (= (str.head_code x) 48) ; '0'
                           (= (str.head_code y) 48) ; '0'
                           (succ (str.tail x) (str.tail y)))
                      (and (not (= x "")) (not (= y ""))
                           (= (str.head_code x) 49) ; '1'
                           (= (str.head_code y) 49) ; '1'
                           (succ (str.tail x) (str.tail y)))
                      (and (not (= x "")) (not (= y ""))
                           (= (str.head_code x) 48) ; '0'
                           (= (str.head_code y) 49) ; '1'
                           (succH (str.tail x) (str.tail y))))
                  ; definition of succH
                  (or (and (= x "")
                           (= y ""))
                      (and (not (= x "")) (not (= y ""))
                           (= (str.head_code x) 49) ; '1'
                           (= (str.head_code y) 48) ; '0'
                           (succH (str.tail x) (str.tail y))))))

(declare-fun x () String)
(declare-fun y () String)

(assert (str.in.re x
         (re.++
           (re.+ (re.union (str.to.re "0") (str.to.re "1")))
           (re.union (str.to.re "0") (str.to.re "1")))))
(assert (succ x y))

(check-sat)
