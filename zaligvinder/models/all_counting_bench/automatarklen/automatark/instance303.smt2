(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d{4,6})
(assert (str.in_re X (re.++ ((_ re.loop 4 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(0)44[\s]{0,1}[\-]{0,1}[\s]{0,1}2[\s]{0,1}[1-9]{1}[0-9]{6}$
(assert (str.in_re X (re.++ (str.to_re "044") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "2") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\/[a-zA-Z0-9]{32}\.jar/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".jar/U\u{0a}"))))
; Subject\u{3a}\d+zmnjgmomgbdz\u{2f}zzmw\.gzt
(assert (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.range "0" "9")) (str.to_re "zmnjgmomgbdz/zzmw.gzt\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
