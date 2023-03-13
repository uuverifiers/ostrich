(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Uin=\s+\.htaServerTheef2trustyfiles\x2EcomlogsHost\x3A
(assert (str.in_re X (re.++ (str.to_re "Uin=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".htaServerTheef2trustyfiles.comlogsHost:\u{0a}"))))
; /^.{27}/sR
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 27 27) re.allchar) (str.to_re "/sR\u{0a}"))))
; /\u{25}3D$/Im
(assert (str.in_re X (str.to_re "/%3D/Im\u{0a}")))
(check-sat)
