(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9]+
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; YWRtaW46cGFzc3dvcmQ\s+www\x2Ealfacleaner\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "YWRtaW46cGFzc3dvcmQ") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.alfacleaner.com\u{0a}")))))
; NETObserve\d+Host\u{3a}ohgdhkzfhdzo\u{2f}uwpOK\r\nHost\x3AHWAEname\u{2e}cnnic\u{2e}cn
(assert (str.in_re X (re.++ (str.to_re "NETObserve") (re.+ (re.range "0" "9")) (str.to_re "Host:ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}Host:HWAEname.cnnic.cn\u{0a}"))))
; /^\/[A-Z]{6}$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 6 6) (re.range "A" "Z")) (str.to_re "/U\u{0a}"))))
(check-sat)
