;test regex @"^(N|(A|B|C|D|E1|E2|E3){1,})$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.union (str.to_re "N") (re.++ (re.* (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "A") (str.to_re "B")) (str.to_re "C")) (str.to_re "D")) (re.++ (str.to_re "E") (str.to_re "1"))) (re.++ (str.to_re "E") (str.to_re "2"))) (re.++ (str.to_re "E") (str.to_re "3")))) ((_ re.loop 1 1) (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "A") (str.to_re "B")) (str.to_re "C")) (str.to_re "D")) (re.++ (str.to_re "E") (str.to_re "1"))) (re.++ (str.to_re "E") (str.to_re "2"))) (re.++ (str.to_re "E") (str.to_re "3")))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)