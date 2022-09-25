(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)
(declare-const m String)
(declare-const n String)

(assert (= (str.++ x y) (str.++ m n) ) )

(assert (str.in.re n (re.* (str.to.re "abc") ) ) )

(assert (< (str.len x) (str.len m) ) )



(check-sat)
(get-model)

