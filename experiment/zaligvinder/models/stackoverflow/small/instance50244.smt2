;test regex ([AC-FHKNPRTV-Y]\d{2}|D6W)[0-9AC-FHKNPRTV-Y]{4}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "A") (re.union (re.range "C" "F") (re.union (str.to_re "H") (re.union (str.to_re "K") (re.union (str.to_re "N") (re.union (str.to_re "P") (re.union (str.to_re "R") (re.union (str.to_re "T") (re.range "V" "Y"))))))))) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "D") (re.++ (str.to_re "6") (str.to_re "W")))) ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.union (str.to_re "A") (re.union (re.range "C" "F") (re.union (str.to_re "H") (re.union (str.to_re "K") (re.union (str.to_re "N") (re.union (str.to_re "P") (re.union (str.to_re "R") (re.union (str.to_re "T") (re.range "V" "Y"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)