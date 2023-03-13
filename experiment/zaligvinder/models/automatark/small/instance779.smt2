(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(6334)[5-9](\d{11}$|\d{13,14}$))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}6334") (re.range "5" "9") (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 14) (re.range "0" "9"))))))
; installs\x2Eseekmo\x2Ecom\s+spyblini\x2EiniUpdateUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "installs.seekmo.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblini.iniUpdateUser-Agent:\u{0a}")))))
(check-sat)
