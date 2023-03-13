(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{5}-\d{4}|\d{5}|[A-Z]\d[A-Z] \d[A-Z]\d$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.range "A" "Z") (re.range "0" "9") (re.range "A" "Z") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "0" "9") (str.to_re "\u{0a}"))))))
(check-sat)
