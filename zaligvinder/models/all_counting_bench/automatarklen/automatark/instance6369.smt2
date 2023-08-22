(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+-]?\d+(\,\d{2})? *?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (str.to_re "\u{0a}")))))
; spyblpat.*is[^\n\r]*BarFrom\x3AHost\x3Agdvsotuqwsg\u{2f}dxt\.hdPASSW=
(assert (not (str.in_re X (re.++ (str.to_re "spyblpat") (re.* re.allchar) (str.to_re "is") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "BarFrom:Host:gdvsotuqwsg/dxt.hdPASSW=\u{0a}")))))
; ^[0-9][0-9,]*[0-9]$
(assert (not (str.in_re X (re.++ (re.range "0" "9") (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.range "0" "9") (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
