(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-f0-9]{32}\/\d{10}\/[a-f0-9]{32}\/\d{10}\.tpl$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re ".tpl/U\u{0a}")))))
; toolbarplace\x2Ecom[^\n\r]*Server[^\n\r]*X-Mailer\u{3a}\sUser-Agent\u{3a}Host\x3ABar\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (re.++ (str.to_re "toolbarplace.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Server") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "User-Agent:Host:Bar/newsurfer4/\u{0a}")))))
; Handyst=ClassStopperHost\x3ASpamBlockerUtility
(assert (not (str.in_re X (str.to_re "Handyst=ClassStopperHost:SpamBlockerUtility\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
