(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Uin=encodernotification\x2Ftoolbar\x2FHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "Uin=encodernotification\u{13}/toolbar/Host:User-Agent:\u{0a}"))))
; ^\d{1,8}$|^\d{1,3},\d{3}$|^\d{1,2},\d{3},\d{3}$
(assert (str.in_re X (re.union ((_ re.loop 1 8) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\?[a-f0-9]{4}$/miU
(assert (not (str.in_re X (re.++ (str.to_re "/?") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/miU\u{0a}")))))
(check-sat)
