(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(.){0,20}$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 20) re.allchar) (str.to_re "\u{0a}")))))
; GmbH\d+Host\x3A\w+adblock\x2Elinkz\x2EcomUser-Agent\x3Aemail
(assert (str.in_re X (re.++ (str.to_re "GmbH") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "adblock.linkz.comUser-Agent:email\u{0a}"))))
; WindowsAcmeReferer\x3A
(assert (str.in_re X (str.to_re "WindowsAcmeReferer:\u{0a}")))
(check-sat)
