(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-z]{2,3}(\.[a-zA-Z][a-zA-Z_$0-9]*)*)\.([A-Z][a-zA-Z_$0-9]*)$
(assert (not (str.in_re X (re.++ (str.to_re ".\u{0a}") ((_ re.loop 2 3) (re.range "a" "z")) (re.* (re.++ (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "$") (re.range "0" "9"))))) (re.range "A" "Z") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "$") (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
