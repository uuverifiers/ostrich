(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d{5})|(\d{5}-\d{4})|([A-CEGHJ-NPR-TV-Z]\d[A-CEGHJ-NPR-TV-Z]\s\d[A-CEGHJ-NPR-TV-Z]\d))$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "V" "Z")) (re.range "0" "9") (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "V" "Z")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "0" "9") (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "V" "Z")) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; (<input )(.*?)(>)
(assert (str.in_re X (re.++ (str.to_re "<input ") (re.* re.allchar) (str.to_re ">\u{0a}"))))
; ^#?([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "#")) ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (re.opt ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)