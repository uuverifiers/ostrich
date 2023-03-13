(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((5)/(1|2|5)/([0-9])/([0-9])/([0-9])/([0-9])/([0-9])/([0-9])/([2-9]))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}5/") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "5")) (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "2" "9")))))
; ^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})$
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.* (re.++ (re.opt (re.union (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "@") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.* (re.++ (re.opt (re.union (str.to_re ".") (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re ".\u{0a}") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))))))
(check-sat)
