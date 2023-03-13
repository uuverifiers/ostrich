(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[13][a-zA-Z0-9]{26,33}$
(assert (str.in_re X (re.++ (re.union (str.to_re "1") (str.to_re "3")) ((_ re.loop 26 33) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /\u{2e}ram?([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ra") (re.opt (str.to_re "m")) (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; nick_name=CIA-Testsearchnuggetprotocolframe_ver2MailerToolbarUser-Agent\u{3a}fromEnTrY
(assert (str.in_re X (str.to_re "nick_name=CIA-Testsearchnugget\u{13}protocolframe_ver2MailerToolbarUser-Agent:fromEnTrY\u{0a}")))
; <!*[^<>]*>
(assert (str.in_re X (re.++ (str.to_re "<") (re.* (str.to_re "!")) (re.* (re.union (str.to_re "<") (str.to_re ">"))) (str.to_re ">\u{0a}"))))
(check-sat)
