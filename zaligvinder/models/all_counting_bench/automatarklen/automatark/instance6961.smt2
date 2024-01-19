(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; vbwwwc\.goclick\.compassword\x3B0\x3BIncorrect
(assert (str.in_re X (str.to_re "vbwwwc.goclick.compassword;0;Incorrect\u{0a}")))
; X-Mailer\x3A.*\x2Frss.*Desktopcargo=report\<\x2Ftitle\>
(assert (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.* re.allchar) (str.to_re "/rss") (re.* re.allchar) (str.to_re "Desktopcargo=report</title>\u{0a}"))))
; PortaUser-Agent\x3AHost\x3A
(assert (str.in_re X (str.to_re "PortaUser-Agent:Host:\u{0a}")))
; (([a-zA-Z]{3}[0-9]{3})|(\w{2}-\w{2}-\w{2})|([0-9]{2}-[a-zA-Z]{3}-[0-9]{1})|([0-9]{1}-[a-zA-Z]{3}-[0-9]{2})|([a-zA-Z]{1}-[0-9]{3}-[a-zA-Z]{2}))
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "-") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "-") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "-") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
