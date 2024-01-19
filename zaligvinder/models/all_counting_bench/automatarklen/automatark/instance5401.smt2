(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{4})-((0[1-9])|(1[0-2]))-(0[1-9]|[12][0-9]|3[01])$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "\u{0a}"))))
; ^((\d{5}-\d{4})|(\d{5})|([A-Z]\d[A-Z]\s\d[A-Z]\d))$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.range "A" "Z") (re.range "0" "9") (re.range "A" "Z") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "0" "9") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; (:(6553[0-5]|655[0-2][0-9]\d|65[0-4](\d){2}|6[0-4](\d){3}|[1-5](\d){4}|[1-9](\d){0,3}))?
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re ":") (re.union (re.++ (str.to_re "6553") (re.range "0" "5")) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "65") (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; ^([0-1])*$
(assert (str.in_re X (re.++ (re.* (re.range "0" "1")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
