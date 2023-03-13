(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[A-Za-z0-9]+\/[A-Za-z0-9]+\.php\?[A-Za-z0-9\x2B\x2F\x3D]{300}/Ui
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".php?") ((_ re.loop 300 300) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/") (str.to_re "="))) (str.to_re "/Ui\u{0a}"))))
; ((FI|HU|LU|MT|SI)-?)?[0-9]{8}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "FI") (str.to_re "HU") (str.to_re "LU") (str.to_re "MT") (str.to_re "SI")) (re.opt (str.to_re "-")))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (\/\*(\s*|.*?)*\*\/)|(--.*)
(assert (str.in_re X (re.union (re.++ (str.to_re "/*") (re.* (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar))) (str.to_re "*/")) (re.++ (str.to_re "\u{0a}--") (re.* re.allchar)))))
(check-sat)
