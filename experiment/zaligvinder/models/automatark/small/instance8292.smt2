(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{4}\s{0,1}[a-zA-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}ram/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ram/i\u{0a}"))))
; ^((\d{5}-\d{4})|(\d{5})|([AaBbCcEeGgHhJjKkLlMmNnPpRrSsTtVvXxYy]\d[A-Za-z]\s?\d[A-Za-z]\d))$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.union (str.to_re "A") (str.to_re "a") (str.to_re "B") (str.to_re "b") (str.to_re "C") (str.to_re "c") (str.to_re "E") (str.to_re "e") (str.to_re "G") (str.to_re "g") (str.to_re "H") (str.to_re "h") (str.to_re "J") (str.to_re "j") (str.to_re "K") (str.to_re "k") (str.to_re "L") (str.to_re "l") (str.to_re "M") (str.to_re "m") (str.to_re "N") (str.to_re "n") (str.to_re "P") (str.to_re "p") (str.to_re "R") (str.to_re "r") (str.to_re "S") (str.to_re "s") (str.to_re "T") (str.to_re "t") (str.to_re "V") (str.to_re "v") (str.to_re "X") (str.to_re "x") (str.to_re "Y") (str.to_re "y")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; A-311[^\n\r]*Attached\sHost\x3AWordmyway\.comhoroscope2
(assert (str.in_re X (re.++ (str.to_re "A-311") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Attached") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:Wordmyway.comhoroscope2\u{0a}"))))
; ((IT|LV)-?)?[0-9]{11}
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "IT") (str.to_re "LV")) (re.opt (str.to_re "-")))) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)