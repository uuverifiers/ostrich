(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; iz=Referer\x3Aoffers\x2Ebullseye-network\x2Ecom
(assert (str.in_re X (str.to_re "iz=Referer:offers.bullseye-network.com\u{0a}")))
; ((([7-9])(\d{3})([-])(\d{4}))|(([7-9])(\d{7})))
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "7" "9") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "7" "9") ((_ re.loop 7 7) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(b|B)(f|F)(p|P)(o|O)(\s*||\s*C(/|)O\s*)[0-9]{1,4}
(assert (str.in_re X (re.++ (re.union (str.to_re "b") (str.to_re "B")) (re.union (str.to_re "f") (str.to_re "F")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "o") (str.to_re "O")) (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "C/O") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
