(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{5}\-\d{3}
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; OSSProxyHost\x3ASubject\u{3a}s_sq=aolsnssignin
(assert (not (str.in_re X (str.to_re "OSSProxyHost:Subject:s_sq=aolsnssignin\u{0a}"))))
(check-sat)
