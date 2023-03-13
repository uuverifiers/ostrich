(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [a-z]{1}[a-z0-9\-_\.]{2,24}@tlen\.pl
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "a" "z")) ((_ re.loop 2 24) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_") (str.to_re "."))) (str.to_re "@tlen.pl\u{0a}"))))
(check-sat)
