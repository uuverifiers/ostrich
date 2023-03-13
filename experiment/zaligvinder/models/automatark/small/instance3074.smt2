(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\.exePass-OnHost\x3A\.exe\x2Ftoolbar\x2F
(assert (not (str.in_re X (str.to_re "Host:.exePass-OnHost:.exe/toolbar/\u{0a}"))))
; ^\d{5}(\-)(\d{3})?$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") (re.opt ((_ re.loop 3 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; Contact\d+Host\x3A[^\n\r]*User-Agent\x3AHost\u{3a}MailHost\u{3a}MSNLOGOVN
(assert (not (str.in_re X (re.++ (str.to_re "Contact") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:Host:MailHost:MSNLOGOVN\u{0a}")))))
; Ready\s+Eye.*http\x3A\x2F\x2Fsupremetoolbar
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Eye") (re.* re.allchar) (str.to_re "http://supremetoolbar\u{0a}"))))
; \x2APORT3\x2A\s+Warez.*X-Mailer\x3ASubject\x3AKEY=
(assert (not (str.in_re X (re.++ (str.to_re "*PORT3*") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Warez") (re.* re.allchar) (str.to_re "X-Mailer:\u{13}Subject:KEY=\u{0a}")))))
(check-sat)
