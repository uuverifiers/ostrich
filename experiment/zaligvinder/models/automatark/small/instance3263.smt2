(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{2,4}
(assert (str.in_re X (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \{[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}\}
(assert (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "}\u{0a}"))))
; [A-Za-z](\.[A-Za-z0-9]|\-[A-Za-z0-9]|_[A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9])(\.[A-Za-z0-9]|\-[A-Za-z0-9]|_[A-Za-z0-9]|[A-Za-z0-9])*
(assert (not (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.union (re.++ (str.to_re ".") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "_") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")))) (re.* (re.union (re.++ (str.to_re ".") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "_") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^([-+]?(\d+\.?\d*|\d*\.?\d+)([Ee][-+]?[0-2]?\d{1,2})?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.union (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9")))) (re.opt (re.++ (re.union (str.to_re "E") (str.to_re "e")) (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.range "0" "2")) ((_ re.loop 1 2) (re.range "0" "9")))))))
(check-sat)
