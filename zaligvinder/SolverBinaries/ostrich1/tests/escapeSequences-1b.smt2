(set-logic QF_S)


(declare-fun x () String)
(declare-fun y () String)

(assert (= x "\x68\145\x6cl"))

;sat
(assert (str.in.re x (re.* (re.charrange (char.from-int 97) (char.from-int 117)))))
(check-sat)

(check-sat)
