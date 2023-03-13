(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]\w{0,30}$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 0 30) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; Host\x3A\s+www\.iggsey\.comcs\x2Esmartshopper\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.iggsey.comcs.smartshopper.com\u{0a}")))))
; /setup=[a-z]$/Ui
(assert (str.in_re X (re.++ (str.to_re "/setup=") (re.range "a" "z") (str.to_re "/Ui\u{0a}"))))
; NETObserve\d+Host\u{3a}ohgdhkzfhdzo\u{2f}uwpOK\r\nHost\x3AHWAEname\u{2e}cnnic\u{2e}cn
(assert (str.in_re X (re.++ (str.to_re "NETObserve") (re.+ (re.range "0" "9")) (str.to_re "Host:ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}Host:HWAEname.cnnic.cn\u{0a}"))))
(check-sat)
