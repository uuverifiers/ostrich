(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?(\d?\d?\d?,?)?(\d{3}\,?)*(\.?\d+)$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.++ (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}") (re.opt (str.to_re ".")) (re.+ (re.range "0" "9"))))))
; Web-Mail\dHost\x3AHost\x3ALOG
(assert (not (str.in_re X (re.++ (str.to_re "Web-Mail") (re.range "0" "9") (str.to_re "Host:Host:LOG\u{0a}")))))
; /logo\.png\u{3f}(sv\u{3d}\d{1,3})?\u{26}tq\u{3d}.*?SoSEU/smiU
(assert (str.in_re X (re.++ (str.to_re "/logo.png?") (re.opt (re.++ (str.to_re "sv=") ((_ re.loop 1 3) (re.range "0" "9")))) (str.to_re "&tq=") (re.* re.allchar) (str.to_re "SoSEU/smiU\u{0a}"))))
(check-sat)
