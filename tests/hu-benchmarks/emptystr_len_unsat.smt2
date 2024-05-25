(set-info :status unsat)
(declare-fun a () String)

(assert (str.in_re a (str.to_re "")))
(assert (= (str.len a) 2))

(check-sat)
(get-model)