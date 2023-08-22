(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^\u{20}-\u{7e}\r\n]{3}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
