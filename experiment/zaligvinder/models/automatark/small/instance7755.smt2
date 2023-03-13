(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d*\.?((25)|(50)|(5)|(75)|(0)|(00))?$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re "25") (str.to_re "50") (str.to_re "5") (str.to_re "75") (str.to_re "0") (str.to_re "00"))) (str.to_re "\u{0a}")))))
; ^100$|^100.00$|^\d{0,2}(\.\d{1,2})? *%?$
(assert (str.in_re X (re.union (str.to_re "100") (re.++ (str.to_re "100") re.allchar (str.to_re "00")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; /\d+&/miR
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "&/miR\u{0a}")))))
(check-sat)
