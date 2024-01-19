(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \.([A-Za-z0-9]{2,5}($|\b\?))
(assert (not (str.in_re X (re.++ (str.to_re ".\u{0a}") ((_ re.loop 2 5) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "?")))))
; CodeguruBrowserMyPostStableWeb-MailUser-Agent\x3A195\.225\.
(assert (str.in_re X (str.to_re "CodeguruBrowserMyPostStableWeb-MailUser-Agent:195.225.\u{0a}")))
; /[^&]+&[a-z]=[a-f0-9]{16}&[a-z]=[a-f0-9]{16}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&") (re.range "a" "z") (str.to_re "=") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&") (re.range "a" "z") (str.to_re "=") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; Host\x3AHost\x3Aalertseqepagqfphv\u{2f}sfd
(assert (not (str.in_re X (str.to_re "Host:Host:alertseqepagqfphv/sfd\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
