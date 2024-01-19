(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; href(\s*)=(\s*)('|")http:\/\/(.*)(("|'))
(assert (not (str.in_re X (re.++ (str.to_re "href") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "'") (str.to_re "\u{22}")) (str.to_re "http://") (re.* re.allchar) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "\u{0a}")))))
; vbwwwc\.goclick\.compassword\x3B0\x3BIncorrect
(assert (not (str.in_re X (str.to_re "vbwwwc.goclick.compassword;0;Incorrect\u{0a}"))))
; ^\d+(\.\d{2})?$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; X-Mailer\u{3a}\s+cyber@yahoo\x2EcomcuAgent
(assert (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "cyber@yahoo.comcuAgent\u{0a}"))))
; is\s+lnzzlnbk\u{2f}pkrm\.fin\s+Host\x3A\x2Ftoolbar\x2Fsupremetb
(assert (not (str.in_re X (re.++ (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:/toolbar/supremetb\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
