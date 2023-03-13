(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^\u{20}-\u{7e}\u{0d}\u{0a}]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}")))))
; ^([A-Za-z]{5})([0-9]{4})([A-Za-z]{1})$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; awbeta\.net-nucleus\.com\d
(assert (str.in_re X (re.++ (str.to_re "awbeta.net-nucleus.com") (re.range "0" "9") (str.to_re "\u{0a}"))))
; Host\x3APG=SPEEDBARReferer\u{3a}
(assert (str.in_re X (str.to_re "Host:PG=SPEEDBARReferer:\u{0a}")))
(check-sat)
