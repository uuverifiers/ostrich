(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \.\s|$(\n|\r\n)
(assert (str.in_re X (re.union (re.++ (str.to_re ".") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.++ (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}\u{0a}")) (str.to_re "\u{0a}")))))
; Host\x3A\s+Eyewww\x2Eccnnlc\x2EcomHost\u{3a}Host\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Eyewww.ccnnlc.com\u{13}Host:Host:\u{0a}")))))
; ^\d{1,7}$
(assert (str.in_re X (re.++ ((_ re.loop 1 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; SystemSleuth1\x2E0versionHost\x3AArrowHost\u{3a}3Awebsearch\x2Edrsnsrch\x2EcomhostieiWonHost\u{3a}pjpoptwql\u{2f}rlnj
(assert (str.in_re X (str.to_re "SystemSleuth\u{13}1.0versionHost:ArrowHost:3Awebsearch.drsnsrch.com\u{13}hostieiWonHost:pjpoptwql/rlnj\u{0a}")))
(check-sat)
