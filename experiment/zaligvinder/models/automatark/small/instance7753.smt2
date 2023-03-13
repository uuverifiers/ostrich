(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d{5})|(\d{5}-\d{4})|([A-CEGHJ-NPR-TV-Z]\d[A-CEGHJ-NPR-TV-Z]\s\d[A-CEGHJ-NPR-TV-Z]\d))$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "V" "Z")) (re.range "0" "9") (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "V" "Z")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "0" "9") (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "V" "Z")) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^([0])([1])([1,2,3,4,6,7,8,9])([0-9][0-9][0-9][0-9][0-9][0-9][0-9])
(assert (not (str.in_re X (re.++ (str.to_re "01") (re.union (str.to_re "1") (str.to_re ",") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9")) (str.to_re "\u{0a}") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9")))))
(check-sat)
