(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^01[1,2,3,4,6,7,8,9]\d{7,8}$
(assert (str.in_re X (re.++ (str.to_re "01") (re.union (str.to_re "1") (str.to_re ",") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9")) ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
