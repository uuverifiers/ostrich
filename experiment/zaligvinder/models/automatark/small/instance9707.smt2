(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\w+),\s+(\w+)\s+ (\((\w+)\)\s+)? (\w+),\s+(\w+)[^\d]+ (\d+)\s+(\w+)
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ",") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re " ") (re.opt (re.++ (str.to_re "(") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ")") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re " ") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ",") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.range "0" "9")) (str.to_re " ") (re.+ (re.range "0" "9")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}jpeg/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpeg/i\u{0a}")))))
; ^[A-Z1-9]{5}-[A-Z1-9]{5}-[A-Z1-9]{5}-[A-Z1-9]{5}-[A-Z1-9]{5}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "-") ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "1" "9"))) (str.to_re "\u{0a}")))))
; /\u{2e}ru\/\w+\?\d$/miU
(assert (str.in_re X (re.++ (str.to_re "/.ru/") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "?") (re.range "0" "9") (str.to_re "/miU\u{0a}"))))
; /\.makeMeasurement\s*\u{28}[^\u{3b}]+?Array/i
(assert (str.in_re X (re.++ (str.to_re "/.makeMeasurement") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ";"))) (str.to_re "Array/i\u{0a}"))))
(check-sat)
