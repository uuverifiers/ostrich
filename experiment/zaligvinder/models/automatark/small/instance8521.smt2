(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}xpm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xpm/i\u{0a}"))))
; ^([\w\s\W]+[\w\W]?)\s([\d\-\\\/\w]*)?
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.opt (re.* (re.union (re.range "0" "9") (str.to_re "-") (str.to_re "\u{5c}") (str.to_re "/") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "\u{0a}") (re.+ (re.union (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; /^[a-z]{5}\d=_\d_/C
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 5 5) (re.range "a" "z")) (re.range "0" "9") (str.to_re "=_") (re.range "0" "9") (str.to_re "_/C\u{0a}")))))
(check-sat)
