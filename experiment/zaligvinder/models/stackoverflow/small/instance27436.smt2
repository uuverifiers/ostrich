;test regex "(6553[0-5]|655[0-2]\\d|65[0-4]\\d{2}|6[0-4]\\d{3}|[1-5]\\d{4}|[1-9]\\d{0,3})"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "6553") (re.range "0" "5")) (re.++ (str.to_re "655") (re.++ (re.range "0" "2") (re.++ (str.to_re "\\") (str.to_re "d"))))) (re.++ (str.to_re "65") (re.++ (re.range "0" "4") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d")))))) (re.++ (str.to_re "6") (re.++ (re.range "0" "4") (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d")))))) (re.++ (re.range "1" "5") (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d"))))) (re.++ (re.range "1" "9") (re.++ (str.to_re "\\") ((_ re.loop 0 3) (str.to_re "d"))))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)