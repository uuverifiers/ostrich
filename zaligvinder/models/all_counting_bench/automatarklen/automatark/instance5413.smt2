(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^DOMAIN\\\w+$
(assert (not (str.in_re X (re.++ (str.to_re "DOMAIN\u{5c}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
