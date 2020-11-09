(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun c () String)
(declare-fun d () String)

(assert (= a (str.++ b c)))
(assert (= b (str.++ d c)))

; in a simple membership test, non-greedy quantifiers have exactly the same
; semantics as greedy quantifiers
(assert (str.in.re a (re.+ (re.union (str.to.re "x") (str.to.re "y")))))
(assert (str.in.re c (re.+? (str.to.re "x"))))

(check-sat)
(get-model)
