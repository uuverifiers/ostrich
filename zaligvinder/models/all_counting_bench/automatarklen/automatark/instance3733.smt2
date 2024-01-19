(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x2Edocument\x2EinsertBefore\s*\u{28}[^\x2C]+\u{29}/smi
(assert (str.in_re X (re.++ (str.to_re "/.document.insertBefore") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ","))) (str.to_re ")/smi\u{0a}"))))
; (\d{3}\-\d{2}\-\d{4})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))))
; ^[ABCEGHJKLMNPRSTVXY][0-9][A-Z]\s?[0-9][A-Z][0-9]$
(assert (str.in_re X (re.++ (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "V") (str.to_re "X") (str.to_re "Y")) (re.range "0" "9") (re.range "A" "Z") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (re.range "A" "Z") (re.range "0" "9") (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
