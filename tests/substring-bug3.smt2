; Problem for which OSTRICH previously incorrectly reported unsat

(assert (= "" (str.substr "" 1 0)))
(check-sat)
