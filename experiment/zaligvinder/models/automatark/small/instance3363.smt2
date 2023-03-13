(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]{1}\w{1,3}) (\d{1}[A-Z]{2})$
(assert (not (str.in_re X (re.++ (str.to_re " \u{0a}") ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z"))))))
(check-sat)
