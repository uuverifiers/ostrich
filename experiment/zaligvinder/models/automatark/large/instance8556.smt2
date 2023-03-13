(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0][5][0]-\d{7}|[0][5][2]-\d{7}|[0][5][4]-\d{7}|[0][5][7]-\d{7}|[0][7][7]-\d{7}|[0][2]-\d{7}|[0][3]-\d{7}|[0][4]-\d{7}|[0][8]-\d{7}|[0][9]-\d{7}|[0][5][0]\d{7}|[0][5][2]\d{7}|[0][5][4]\d{7}|[0][5][7]\d{7}|[0][7][7]\d{7}|[0][2]\d{7}|[0][3]\d{7}|[0][4]\d{7}|[0][8]\d{7}|[0][9]\d{7}$
(assert (str.in_re X (re.union (re.++ (str.to_re "050-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "052-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "054-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "057-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "077-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "02-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "03-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "04-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "08-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "09-") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "050") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "052") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "054") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "057") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "077") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "02") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "03") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "04") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "08") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "09") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^\+[0-9]{1,3}\([0-9]{3}\)[0-9]{7}$
(assert (str.in_re X (re.++ (str.to_re "+") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3A\x2Fta\x2FNEWS\x2Fyayad\x2Ecom
(assert (not (str.in_re X (str.to_re "Host:/ta/NEWS/yayad.com\u{13}\u{0a}"))))
; /\u{2e}plp([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.plp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
