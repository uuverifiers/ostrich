(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; snprtz\x7Cdialnoref\x3D\u{25}user\x5FidPG=SPEEDBAR
(assert (str.in_re X (str.to_re "snprtz|dialnoref=%user_idPG=SPEEDBAR\u{0a}")))
; ^\d{2,6}-\d{2}-\d$
(assert (str.in_re X (re.++ ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
(check-sat)
