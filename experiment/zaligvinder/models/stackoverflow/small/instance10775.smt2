;test regex ^ ((C[A|F|L]|ME)) (\d{3}) (\d{3}) \. (PDF) 
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (re.union (re.++ (str.to_re "C") (re.union (str.to_re "A") (re.union (str.to_re "|") (re.union (str.to_re "F") (re.union (str.to_re "|") (str.to_re "L")))))) (re.++ (str.to_re "M") (str.to_re "E"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re ".") (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re "P") (re.++ (str.to_re "D") (str.to_re "F"))) (str.to_re " "))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)