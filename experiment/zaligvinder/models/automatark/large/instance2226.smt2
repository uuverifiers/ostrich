(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\.\./|[a-zA-Z0-9_/\-\\])*\.[a-zA-Z0-9]+)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.union (str.to_re "../") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "/") (str.to_re "-") (str.to_re "\u{5c}"))) (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))))
; ^[ .a-zA-Z0-9:-]{1,150}$
(assert (str.in_re X (re.++ ((_ re.loop 1 150) (re.union (str.to_re " ") (str.to_re ".") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ":") (str.to_re "-"))) (str.to_re "\u{0a}"))))
(check-sat)
