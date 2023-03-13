(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^100$|^[0-9]{1,2}$|^[0-9]{1,2}\,[0-9]{1,3}$
(assert (str.in_re X (re.union (str.to_re "100") ((_ re.loop 1 2) (re.range "0" "9")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
