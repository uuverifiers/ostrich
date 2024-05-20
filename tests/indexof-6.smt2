; UNSAT

(set-option :print-success false)
(set-logic QF_SLIA)

(define-fun y () String "\u{0}\u{0}?#")

(assert (> 0 (str.indexof y "#" 2)))

(check-sat)
(exit)
