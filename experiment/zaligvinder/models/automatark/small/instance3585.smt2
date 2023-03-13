(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^\n -~\r]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0a}") (re.range " " "~") (str.to_re "\u{0d}"))) (str.to_re "/P\u{0a}")))))
(check-sat)
