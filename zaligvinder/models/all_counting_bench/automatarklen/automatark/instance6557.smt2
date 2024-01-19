(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \w*
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^[^\\\/\?\*\"\>\<\:\|]*$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "\u{5c}") (str.to_re "/") (str.to_re "?") (str.to_re "*") (str.to_re "\u{22}") (str.to_re ">") (str.to_re "<") (str.to_re ":") (str.to_re "|"))) (str.to_re "\u{0a}"))))
; (-?(\d*\.\d{1}?\d*|\d{1,}))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (re.union (re.++ (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.+ (re.range "0" "9"))))))
; ^\{?[a-fA-F\d]{32}\}?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "{")) ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (re.opt (str.to_re "}")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
