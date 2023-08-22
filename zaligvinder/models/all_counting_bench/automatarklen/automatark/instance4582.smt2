(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Reports[^\n\r]*User-Agent\x3A.*largePass-Onseqepagqfphv\u{2f}sfd
(assert (not (str.in_re X (re.++ (str.to_re "Reports") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "largePass-Onseqepagqfphv/sfd\u{0a}")))))
; (^(09|9)[1][1-9]\\d{7}$)|(^(09|9)[3][12456]\\d{7}$)
(assert (str.in_re X (re.union (re.++ (re.union (str.to_re "09") (str.to_re "9")) (str.to_re "1") (re.range "1" "9") (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d"))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "09") (str.to_re "9")) (str.to_re "3") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "4") (str.to_re "5") (str.to_re "6")) (str.to_re "\u{5c}") ((_ re.loop 7 7) (str.to_re "d"))))))
; Host\u{3a}[^\n\r]*A-311\s+lnzzlnbk\u{2f}pkrm\.finSubject\u{3a}Basic
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "A-311") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.finSubject:Basic\u{0a}")))))
; www\.actualnames\.com\s+toolbar_domain_redirect\s+Contactfrom=GhostVoiceServer
(assert (str.in_re X (re.++ (str.to_re "www.actualnames.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "toolbar_domain_redirect") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Contactfrom=GhostVoiceServer\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
