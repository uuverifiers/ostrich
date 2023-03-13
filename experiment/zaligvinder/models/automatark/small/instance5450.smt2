(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ProtoSubject\u{3a}source\=IncrediFindProjectAgentHost\x3AHost\x3AHost\x3A
(assert (not (str.in_re X (str.to_re "ProtoSubject:source=IncrediFindProjectAgentHost:Host:Host:\u{0a}"))))
; trackwww\x2Ealfacleaner\x2Ecom
(assert (str.in_re X (str.to_re "trackwww.alfacleaner.com\u{0a}")))
; (8[^0]\d|8\d[^0]|[0-79]\d{2})-\d{3}-\d{4}
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "8") (re.comp (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "8") (re.range "0" "9") (re.comp (str.to_re "0"))) (re.++ (re.union (re.range "0" "7") (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
