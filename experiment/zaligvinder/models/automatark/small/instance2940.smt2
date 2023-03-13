(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \binterface\b.*(\bI[_]\w*\b)
(assert (str.in_re X (re.++ (str.to_re "interface") (re.* re.allchar) (str.to_re "\u{0a}I_") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; ^[a-zA-Z][a-zA-Z0-9_]+$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^[SC]{2}[0-9]{6}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "S") (str.to_re "C"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \d\d?\d?\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?
(assert (str.in_re X (re.++ (re.range "0" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
