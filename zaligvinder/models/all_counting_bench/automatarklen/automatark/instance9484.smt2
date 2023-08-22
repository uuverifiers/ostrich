(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+-]?[0-9]+$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^([A-Z]+[a-zA-Z]*)(\s|\-)?([A-Z]+[a-zA-Z]*)?(\s|\-)?([A-Z]+[a-zA-Z]*)?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.+ (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.+ (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}") (re.+ (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z")))))))
; /^slowhttp\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/slowhttp|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; ^([0-9a-f]{0,4}:){2,7}(:|[0-9a-f]{1,4})$
(assert (str.in_re X (re.++ ((_ re.loop 2 7) (re.++ ((_ re.loop 0 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ":"))) (re.union (str.to_re ":") ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f")))) (str.to_re "\u{0a}"))))
; ([0-9a-zA-Z]+)|([0-9a-zA-Z][0-9a-zA-Z\\s]+[0-9a-zA-Z]+)
(assert (str.in_re X (re.union (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "\u{5c}") (str.to_re "s"))) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")))))))
(assert (> (str.len X) 10))
(check-sat)
