;test regex ^ADB_FULL_REQ_[a-fA-F0-9]{12}_(\d{6})_(\d{2}).dat
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "D") (re.++ (str.to_re "B") (re.++ (str.to_re "_") (re.++ (str.to_re "F") (re.++ (str.to_re "U") (re.++ (str.to_re "L") (re.++ (str.to_re "L") (re.++ (str.to_re "_") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "Q") (re.++ (str.to_re "_") (re.++ ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "d") (re.++ (str.to_re "a") (str.to_re "t")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)