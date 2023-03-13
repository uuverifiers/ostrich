(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((25[0-4]|(2[0-4]|1[0-9]|[1-9]?)[0-9]\.){3}(25[0-4]|(2[0-4]|1[0-9]|[1-9]?)[0-9]))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (re.++ (str.to_re "25") (re.range "0" "4")) (re.++ (re.union (re.++ (str.to_re "2") (re.range "0" "4")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.opt (re.range "1" "9"))) (re.range "0" "9") (str.to_re ".")))) (re.union (re.++ (str.to_re "25") (re.range "0" "4")) (re.++ (re.union (re.++ (str.to_re "2") (re.range "0" "4")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.opt (re.range "1" "9"))) (re.range "0" "9")))))))
; (^[0][2][1579]{1})(\d{6,7}$)
(assert (not (str.in_re X (re.++ ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}02") ((_ re.loop 1 1) (re.union (str.to_re "1") (str.to_re "5") (str.to_re "7") (str.to_re "9")))))))
(check-sat)
