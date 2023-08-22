(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SystemSleuth1\x2E0versionHost\x3AArrowHost\u{3a}3Awebsearch\x2Edrsnsrch\x2EcomhostieiWonHost\u{3a}pjpoptwql\u{2f}rlnj
(assert (not (str.in_re X (str.to_re "SystemSleuth\u{13}1.0versionHost:ArrowHost:3Awebsearch.drsnsrch.com\u{13}hostieiWonHost:pjpoptwql/rlnj\u{0a}"))))
; /^Referer\u{3a}[^\r\n]+\/[\w_]{32,}\.html\r$/Hsm
(assert (not (str.in_re X (re.++ (str.to_re "/Referer:") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/.html\u{0d}/Hsm\u{0a}") ((_ re.loop 32 32) (re.union (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
(assert (> (str.len X) 10))
(check-sat)
