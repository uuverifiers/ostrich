(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[0-9A-F]{24}/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/Ui\u{0a}"))))
; ^([0-9]|0[0-9]|1[0-9]|2[0-3]):([0-9]|[0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.union (re.range "0" "9") (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; \x2Fbonzibuddy\x2Forigin\x3DsidefindApofisUser-Agent\x3A
(assert (str.in_re X (str.to_re "/bonzibuddy/origin=sidefindApofisUser-Agent:\u{0a}")))
; Host\x3A\s+\x2Ftoolbar\x2Fsupremetb\s+wjpropqmlpohj\u{2f}lo\x2Ftoolbar\x2Fsupremetb
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/supremetb") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "wjpropqmlpohj/lo/toolbar/supremetb\u{0a}"))))
; 3A\s+URLBlazeHost\x3Atrackhjhgquqssq\u{2f}pjm
(assert (str.in_re X (re.++ (str.to_re "3A") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlazeHost:trackhjhgquqssq/pjm\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
