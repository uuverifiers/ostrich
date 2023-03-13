(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{4},?)+$
(assert (str.in_re X (re.++ (re.+ (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}"))))
; ^(\d)(\.)(\d)+\s(x)\s(10)(e|E|\^)(-)?(\d)+$
(assert (str.in_re X (re.++ (re.range "0" "9") (str.to_re ".") (re.+ (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "x") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "10") (re.union (str.to_re "e") (str.to_re "E") (str.to_re "^")) (re.opt (str.to_re "-")) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
