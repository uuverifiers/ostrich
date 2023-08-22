(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]$
(assert (str.in_re X (re.++ (re.range "A" "Z") (str.to_re "\u{0a}"))))
; ^([A-Z]{0,3}?[0-9]{9}($[0-9]{0}|[A-Z]{1}))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 0 3) (re.range "A" "Z")) ((_ re.loop 9 9) (re.range "0" "9")) (re.union ((_ re.loop 0 0) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")))))))
; ^(\d?)*\.?(\d{1}|\d{2})?$
(assert (str.in_re X (re.++ (re.* (re.opt (re.range "0" "9"))) (re.opt (str.to_re ".")) (re.opt (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /(\u{17}\u{00}|\u{00}\x5C)\u{00}e\u{00}l\u{00}s\u{00}e\u{00}x\u{00}t\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{17}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}e\u{00}l\u{00}s\u{00}e\u{00}x\u{00}t\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
