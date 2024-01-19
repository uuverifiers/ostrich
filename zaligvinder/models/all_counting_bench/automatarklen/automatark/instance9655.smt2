(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^.{27}/sR
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 27 27) re.allchar) (str.to_re "/sR\u{0a}")))))
; this\s+MyBrowser\d+Redirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "this") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MyBrowser") (re.+ (re.range "0" "9")) (str.to_re "Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}")))))
; Referer\x3A.*notification.*qisezhin\u{2f}iqor\.ymspasServer\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Referer:") (re.* re.allchar) (str.to_re "notification\u{13}") (re.* re.allchar) (str.to_re "qisezhin/iqor.ym\u{13}spasServer:\u{0a}"))))
; Host\x3AHost\x3AX-Mailer\u{3a}
(assert (str.in_re X (str.to_re "Host:Host:X-Mailer:\u{13}\u{0a}")))
; /filename=[^\n]*\u{2e}exe/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".exe/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
