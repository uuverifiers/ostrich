(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Uin=encodernotification\x2Ftoolbar\x2FHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "Uin=encodernotification\u{13}/toolbar/Host:User-Agent:\u{0a}"))))
; ^([0]\d|[1][0-2])\/([0-2]\d|[3][0-1])\/([2][01]|[1][6-9])\d{2}(\s([0-1]\d|[2][0-3])(\:[0-5]\d){1,2})?$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (str.to_re "1") (re.range "6" "9"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) ((_ re.loop 1 2) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
