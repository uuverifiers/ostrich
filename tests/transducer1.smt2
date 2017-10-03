(set-logic QF_S)

; Successor transducer

(define-funs-rec ((succ ((x String) (y String)) Bool)
                  (succH ((x String) (y String)) Bool)) (
                  ; definition of succ
                  (or (and (= (seq-head x) (_ bv48 8)) ; '0'
                           (= (seq-head y) (_ bv48 8)) ; '0'
                           (succ (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv49 8)) ; '1'
                           (= (seq-head y) (_ bv49 8)) ; '1'
                           (succ (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv48 8)) ; '0'
                           (= (seq-head y) (_ bv49 8)) ; '1'
                           (succH (seq-tail x) (seq-tail y))))
                  ; definition of succH
                  (or (and (= x "")
                           (= y ""))
                      (and (= (seq-head x) (_ bv49 8)) ; '1'
                           (= (seq-head y) (_ bv48 8)) ; '0'
                           (succH (seq-tail x) (seq-tail y))))))

(declare-fun x () String)
(declare-fun y () String)

(assert (str.in.re x (re.+ (re.union (str.to.re "0") (str.to.re "1")))))
(assert (succ x y))

(check-sat)