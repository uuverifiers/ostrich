(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{4,4}[A-Z0-9](, *\d{4,4})[A-Z0-9]*$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "0" "9")) (re.* (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a},") (re.* (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")))))
; ^(0+[1-9]|[1-9])[0-9]*$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.+ (str.to_re "0")) (re.range "1" "9")) (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
