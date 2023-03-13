(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d+(,\d+)*)+$
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; e(vi?)?
(assert (str.in_re X (re.++ (str.to_re "e") (re.opt (re.++ (str.to_re "v") (re.opt (str.to_re "i")))) (str.to_re "\u{0a}"))))
; /^GET\s\u{2f}[A-F0-9]{152}/m
(assert (str.in_re X (re.++ (str.to_re "/GET") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/") ((_ re.loop 152 152) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "/m\u{0a}"))))
; /\/blog\/images\/3521\.jpg\?v\d{2}=\d{2}\u{26}tq=/Ui
(assert (str.in_re X (re.++ (str.to_re "//blog/images/3521.jpg?v") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "=") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "&tq=/Ui\u{0a}"))))
; ^([1][12]|[0]?[1-9])[\/-]([3][01]|[12]\d|[0]?[1-9])[\/-](\d{4}|\d{2})$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "1") (str.to_re "2"))) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
