(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\xFF\xFE\x3F\u{10}\u{00}\u{00}.{14}[\x2Bx\x2Fa-z0-9]{20}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/\u{ff}\u{fe}?\u{10}\u{00}\u{00}") ((_ re.loop 14 14) re.allchar) ((_ re.loop 20 20) (re.union (str.to_re "+") (str.to_re "x") (str.to_re "/") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/smi\u{0a}")))))
(check-sat)
