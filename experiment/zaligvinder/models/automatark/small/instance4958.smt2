(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\x3AHost\u{3a}Host\x3A000Filelogin_ok\x5EMiniCommand
(assert (str.in_re X (str.to_re "Subject:Host:Host:000Filelogin_ok^MiniCommand\u{0a}")))
; ^(LV-)[0-9]{4}$
(assert (not (str.in_re X (re.++ (str.to_re "LV-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
