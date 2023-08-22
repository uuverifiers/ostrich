;test regex DB(\d{1,4}|[1-5]\d{5}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])\.DB[XBDW](1000|0[1-9]|[1-9]\d{0,2})\.(0|10|[1-9])
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "D") (re.++ (str.to_re "B") (re.++ (re.union (re.union (re.union (re.union (re.union ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (re.range "1" "5") ((_ re.loop 5 5) (re.range "0" "9")))) (re.++ (str.to_re "6") (re.++ (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "65") (re.++ (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "655") (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (str.to_re "6553") (re.range "0" "5"))) (re.++ (str.to_re ".") (re.++ (str.to_re "D") (re.++ (str.to_re "B") (re.++ (re.union (str.to_re "X") (re.union (str.to_re "B") (re.union (str.to_re "D") (str.to_re "W")))) (re.++ (re.union (re.union (str.to_re "1000") (re.++ (str.to_re "0") (re.range "1" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.union (re.union (str.to_re "0") (str.to_re "10")) (re.range "1" "9")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)