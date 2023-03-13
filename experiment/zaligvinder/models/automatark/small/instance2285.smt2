(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(966)(5)[0-9]{8}$
(assert (not (str.in_re X (re.++ (str.to_re "9665") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\.addAnnot\s*\u{28}[^\u{29}]*?points\s*\u{3a}\s*0/i
(assert (str.in_re X (re.++ (str.to_re "/.addAnnot") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re "points") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ":") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "0/i\u{0a}"))))
; ^((\d{5})|(\d{5}-\d{4})|([A-CEGHJ-NPR-TV-Z]\d[A-CEGHJ-NPR-TV-Z]\s\d[A-CEGHJ-NPR-TV-Z]\d))$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "V" "Z")) (re.range "0" "9") (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "V" "Z")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "0" "9") (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "V" "Z")) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^[1-9]{1}[0-9]{3}\s{0,1}?[a-zA-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; Logger.*aresflashdownloader\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Logger") (re.* re.allchar) (str.to_re "aresflashdownloader.com\u{0a}"))))
(check-sat)
