(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\(\d{1,2}(\s\d{1,2}){1,2}\)\s(\d{1,2}(\s\d{1,2}){1,2})((-(\d{1,4})){0,1})$
(assert (not (str.in_re X (re.++ (str.to_re "(") ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 1 2) (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re ")") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 1 4) (re.range "0" "9")))) (str.to_re "\u{0a}") ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 1 2) (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 1 2) (re.range "0" "9"))))))))
(check-sat)
