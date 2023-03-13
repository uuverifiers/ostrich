(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AHost\u{3a}fhfksjzsfu\u{2f}ahm\.uqsHost\x3Afowclxccdxn\u{2f}uxwn\.ddy
(assert (str.in_re X (str.to_re "Host:Host:fhfksjzsfu/ahm.uqsHost:fowclxccdxn/uxwn.ddy\u{0a}")))
; /\.php\?[a-z]{2,8}=[a-z0-9]{2}\u{3a}[a-z0-9]{2}\u{3a}[a-z0-9]{2}\u{3a}[a-z0-9]{2}\u{3a}[a-z0-9]{2}\&[a-z]{2,8}=/U
(assert (str.in_re X (re.++ (str.to_re "/.php?") ((_ re.loop 2 8) (re.range "a" "z")) (str.to_re "=") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "&") ((_ re.loop 2 8) (re.range "a" "z")) (str.to_re "=/U\u{0a}"))))
; dialup\u{5f}vpn\u{40}hermangroup\x2Eorg\s+www\x2Epeer2mail\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "dialup_vpn@hermangroup.org") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.peer2mail.com\u{0a}")))))
; client\x2Ebaigoo\x2EcomUser\x3A
(assert (not (str.in_re X (str.to_re "client.baigoo.comUser:\u{0a}"))))
(check-sat)
