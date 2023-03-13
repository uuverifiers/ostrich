(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([+]|00)39)?((3[1-6][0-9]))(\d{7})$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "00")) (str.to_re "39"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}3") (re.range "1" "6") (re.range "0" "9"))))
; ^[\w\s]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^([0-9]{6}[\s\-]{1}[0-9]{12}|[0-9]{18})$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 12 12) (re.range "0" "9"))) ((_ re.loop 18 18) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; zmnjgmomgbdz\u{2f}zzmw\.gztwww3\.addfreestats\.comKeylogger
(assert (str.in_re X (str.to_re "zmnjgmomgbdz/zzmw.gztwww3.addfreestats.comKeylogger\u{0a}")))
(check-sat)
