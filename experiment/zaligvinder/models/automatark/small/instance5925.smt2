(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9][0-9]{0,2}$
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[$]?[0-9]*(\.)?[0-9]?[0-9]?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re "\u{0a}"))))
; [\\s+,]
(assert (not (str.in_re X (re.++ (re.union (str.to_re "\u{5c}") (str.to_re "s") (str.to_re "+") (str.to_re ",")) (str.to_re "\u{0a}")))))
(check-sat)
