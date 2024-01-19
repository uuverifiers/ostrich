(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(.|\n){0,16}$
(assert (str.in_re X (re.++ ((_ re.loop 0 16) (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
