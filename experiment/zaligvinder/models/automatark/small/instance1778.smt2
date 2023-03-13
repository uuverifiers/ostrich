(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Ready\s+Client\s+MyBrowserHost\u{3a}securityon\x3AHost\x3ARedirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Client") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MyBrowserHost:securityon:Host:Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}")))))
; Explorer\x2Fsto=notificationfind
(assert (str.in_re X (str.to_re "Explorer/sto=notification\u{13}find\u{0a}")))
; /^(\u{00}\u{00}\u{00}\u{00}|.{4}(\u{00}\u{00}\u{00}\u{00}|.{12}))/s
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") (re.++ ((_ re.loop 4 4) re.allchar) (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") ((_ re.loop 12 12) re.allchar)))) (str.to_re "/s\u{0a}"))))
(check-sat)
