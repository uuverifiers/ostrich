(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \D
(assert (not (str.in_re X (re.++ (re.comp (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(Function|Sub)(\s+[\w]+)\([^\(\)]*\)
(assert (not (str.in_re X (re.++ (re.union (str.to_re "Function") (str.to_re "Sub")) (str.to_re "(") (re.* (re.union (str.to_re "(") (str.to_re ")"))) (str.to_re ")\u{0a}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; ^[^']*$
(assert (not (str.in_re X (re.++ (re.* (re.comp (str.to_re "'"))) (str.to_re "\u{0a}")))))
; ^([0-9A-Za-z@.]{1,255})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 255) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "@") (str.to_re "."))) (str.to_re "\u{0a}")))))
; ^((\d[-. ]?)?((\(\d{3}\))|\d{3}))?[-. ]?\d{3}[-. ]?\d{4}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (re.++ (re.range "0" "9") (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))))) (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
