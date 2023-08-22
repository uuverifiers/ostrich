(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$?\d{1,3}(,?\d{3})*(\.\d{1,2})?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (re.opt (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^((.){1,}(\d){1,}(.){0,})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ re.allchar) (re.+ (re.range "0" "9")) (re.* re.allchar)))))
; attachedEverywareHELOBasic
(assert (str.in_re X (str.to_re "attachedEverywareHELOBasic\u{0a}")))
; ^\d{5}-\d{4}|\d{5}|[A-Z]\d[A-Z] \d[A-Z]\d$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.range "A" "Z") (re.range "0" "9") (re.range "A" "Z") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "0" "9") (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
