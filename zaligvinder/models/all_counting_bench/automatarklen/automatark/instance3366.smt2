(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{3}-\d{3}-\d{4})*$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\.makeMeasurement\s*\u{28}[^\u{3b}]+?Array/i
(assert (not (str.in_re X (re.++ (str.to_re "/.makeMeasurement") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ";"))) (str.to_re "Array/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
