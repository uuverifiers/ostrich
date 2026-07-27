(set-logic QF_S)
(set-info :status unsat)

(declare-const r RegLan)

(assert (distinct (re.union r re.none) r))

(check-sat)
