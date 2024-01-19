(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([0-9a-zA-Z]+)|([0-9a-zA-Z][0-9a-zA-Z\\s]+[0-9a-zA-Z]+)
(assert (not (str.in_re X (re.union (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "\u{5c}") (str.to_re "s"))) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))))))))
; ^((\b[A-Z0-9](\w)*\b)|\s)*$
(assert (str.in_re X (re.++ (re.* (re.union (re.++ (re.union (re.range "A" "Z") (re.range "0" "9")) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; ^([1-9]{1}|[1-9]{1}[0-9]{1,3}|[1-5]{1}[0-9]{4}|6[0-4]{1}[0-9]{3}|65[0-4]{1}[0-9]{2}|655[0-2]{1}[0-9]{1}|6553[0-6]{1})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "5")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "6") ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "65") ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "655") ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "6553") ((_ re.loop 1 1) (re.range "0" "6")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
