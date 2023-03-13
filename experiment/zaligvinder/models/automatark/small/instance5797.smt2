(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; GmbH\s+Host\x3AHost\x3AMonitoringGoogle
(assert (not (str.in_re X (re.++ (str.to_re "GmbH") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:MonitoringGoogle\u{0a}")))))
; /g\/\d{9}\/[0-9a-f]{32}\/[0-9]$/U
(assert (str.in_re X (re.++ (str.to_re "/g/") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/") (re.range "0" "9") (str.to_re "/U\u{0a}"))))
(check-sat)
