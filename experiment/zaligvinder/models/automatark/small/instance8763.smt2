(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0|1)+$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "0") (str.to_re "1"))) (str.to_re "\u{0a}"))))
; ovpl\s+\x7D\x7BPort\x3A.*SOAPAction\x3A.*adfsgecoiwnfHost\x3A\x3Fsearch\x3D
(assert (str.in_re X (re.++ (str.to_re "ovpl") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Port:") (re.* re.allchar) (str.to_re "SOAPAction:") (re.* re.allchar) (str.to_re "adfsgecoiwnf\u{1b}Host:?search=\u{0a}"))))
; areHost\x3Ae2give\.comHost\u{3a}X-Mailer\x3AsportsHost\x3AToolbar
(assert (not (str.in_re X (str.to_re "areHost:e2give.comHost:X-Mailer:\u{13}sportsHost:Toolbar\u{0a}"))))
; Host\x3A\dName=Your\+Host\+is\x3A.*has\s+ComputerKeylogger\x2EcomHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Name=Your+Host+is:") (re.* re.allchar) (str.to_re "has") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ComputerKeylogger.comHost:\u{0a}")))))
; (1[8,9]|20)[0-9]{2}
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "8") (str.to_re ",") (str.to_re "9"))) (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
