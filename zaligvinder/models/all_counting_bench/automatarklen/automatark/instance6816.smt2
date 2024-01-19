(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-fA-F])*$
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}"))))
; ^[9]9\d{10}|^[5]\d{10}
(assert (not (str.in_re X (re.union (re.++ (str.to_re "99") ((_ re.loop 10 10) (re.range "0" "9"))) (re.++ (str.to_re "5") ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; EFError.*\x2Fcs\x2Fpop4\x2F[^\n\r]*
(assert (str.in_re X (re.++ (str.to_re "EFError") (re.* re.allchar) (str.to_re "/cs/pop4/") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; Host\x3A\dName=Your\+Host\+is\x3A.*has\s+ComputerKeylogger\x2EcomHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Name=Your+Host+is:") (re.* re.allchar) (str.to_re "has") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ComputerKeylogger.comHost:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
