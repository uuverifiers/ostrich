(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; jsp\d+Host\x3A\d+moreKontikiHost\u{3a}AcmeEvilFTP
(assert (str.in_re X (re.++ (str.to_re "jsp") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "moreKontikiHost:AcmeEvilFTP\u{0a}"))))
; \r\nSTATUS\x3A\dHost\u{3a}Referer\x3AServerSubject\u{3a}
(assert (str.in_re X (re.++ (str.to_re "\u{0d}\u{0a}STATUS:") (re.range "0" "9") (str.to_re "Host:Referer:ServerSubject:\u{0a}"))))
; /^\/\?[a-f0-9]{32}$/U
(assert (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
