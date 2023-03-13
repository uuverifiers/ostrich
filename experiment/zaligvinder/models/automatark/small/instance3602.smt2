(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d*\.?(((5)|(0)|))?$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re "5") (str.to_re "0"))) (str.to_re "\u{0a}")))))
; ^[0-9]{4} {0,1}[A-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; ^\d*(\.\d*)$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (str.to_re "\u{0a}.") (re.* (re.range "0" "9")))))
; ^([0-9]|[1-9][0-9]|[1-9][0-9][0-9])$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
