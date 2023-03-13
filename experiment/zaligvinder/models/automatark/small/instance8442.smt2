(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{8,8}$|^[SC]{2,2}\d{6,6}$
(assert (not (str.in_re X (re.union ((_ re.loop 8 8) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "S") (str.to_re "C"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^(([0-2])?([0-9]))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.range "0" "2")) (re.range "0" "9")))))
; ^(\d{1,8}|(\d{0,8}\.{1}\d{1,2}){1})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 8) (re.range "0" "9")) ((_ re.loop 1 1) (re.++ ((_ re.loop 0 8) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(check-sat)
