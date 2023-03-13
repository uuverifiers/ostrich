(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\d{2}[\-\/]\d{2}[\-\/]\d{4}$/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "/")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/\u{0a}")))))
(check-sat)
