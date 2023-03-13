(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; X-Mailer\x3A\s+Toolbar\s+supremetoolbar\.comst=Host\x3A\x5Chome\/lordofsearchMicrosoftHost\u{3a}\+The\+password\+is\x3A
(assert (not (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "supremetoolbar.comst=Host:\u{5c}home/lordofsearchMicrosoftHost:+The+password+is:\u{0a}")))))
; /[a-z\d\u{2f}\u{2b}\u{3d}]{100}/AGPi
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 100 100) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "/") (str.to_re "+") (str.to_re "="))) (str.to_re "/AGPi\u{0a}"))))
; ^1000([.][0]{1,3})?$|^\d{1,3}$|^\d{1,3}([.]\d{1,3})$|^([.]\d{1,3})$
(assert (str.in_re X (re.union (re.++ (str.to_re "1000") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (str.to_re "0"))))) ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}.") ((_ re.loop 1 3) (re.range "0" "9"))))))
(check-sat)
