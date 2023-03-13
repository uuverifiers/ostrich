(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0]{0,1}[0-7]{3})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "0")) ((_ re.loop 3 3) (re.range "0" "7")))))
; \.fcgi[^\n\r]*Host\x3A\s\x5D\u{25}20\x5BPort_NETObserveTM_SEARCH3
(assert (str.in_re X (re.++ (str.to_re ".fcgi") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "]%20[Port_NETObserveTM_SEARCH3\u{0a}"))))
; (((\+44)? ?(\(0\))? ?)|(0))( ?[0-9]{3,4}){3}
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "+44")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(0)")) (re.opt (str.to_re " "))) (str.to_re "0")) ((_ re.loop 3 3) (re.++ (re.opt (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
