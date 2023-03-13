(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^connect\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/connect|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; /\/html\/license_[0-9A-F]{550,}\.html$/Ui
(assert (str.in_re X (re.++ (str.to_re "//html/license_.html/Ui\u{0a}") ((_ re.loop 550 550) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F"))))))
; [a-zA-Z]+\-?[a-zA-Z]+
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; attachedEverywareHELOBasic
(assert (not (str.in_re X (str.to_re "attachedEverywareHELOBasic\u{0a}"))))
(check-sat)
