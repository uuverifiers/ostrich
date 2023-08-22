(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0][5][0]-\d{7}|[0][5][2]-\d{7}|[0][5][4]-\d{7}|[0][5][7]-\d{7}$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "050-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "052-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "054-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "057-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^\d{5}(\-)(\d{3})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") (re.opt ((_ re.loop 3 3) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^(\d|,)*\d*$
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; FTPHost\x3AUser-Agent\u{3a}User\x3AdistID=deskwizz\x2Ecom
(assert (not (str.in_re X (str.to_re "FTPHost:User-Agent:User:distID=deskwizz.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
