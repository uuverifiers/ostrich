(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \+44\s\(0\)\s\d{2}\s\d{4}\s\d{4}
(assert (not (str.in_re X (re.++ (str.to_re "+44") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "(0)") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (vi(v))?d
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "viv")) (str.to_re "d\u{0a}")))))
; ^([GB])*(([1-9]\d{8})|([1-9]\d{11}))$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "G") (str.to_re "B"))) (re.union (re.++ (re.range "1" "9") ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 11 11) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
