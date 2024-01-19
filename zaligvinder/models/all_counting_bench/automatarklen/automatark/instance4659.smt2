(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^1[34][0-9][0-9]\/((1[0-2])|([1-9]))\/(([12][0-9])|(3[01])|[1-9])$
(assert (not (str.in_re X (re.++ (str.to_re "1") (re.union (str.to_re "3") (str.to_re "4")) (re.range "0" "9") (re.range "0" "9") (str.to_re "/") (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")) (str.to_re "/") (re.union (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.range "1" "9")) (str.to_re "\u{0a}")))))
; www\x2Elookster\x2Enet\s+Host\x3ADesktopBlade
(assert (str.in_re X (re.++ (str.to_re "www.lookster.net") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:DesktopBlade\u{0a}"))))
; ^([EV])?\d{3,3}(\.\d{1,2})?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "E") (str.to_re "V"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^1+0+$
(assert (not (str.in_re X (re.++ (re.+ (str.to_re "1")) (re.+ (str.to_re "0")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
