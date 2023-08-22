;test regex ((?:0\.\d{3}|1\.[0|1|2|3|4|5]\d{2}|1\.600))
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "0") (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "1") (re.++ (str.to_re ".") (re.++ (re.union (str.to_re "0") (re.union (str.to_re "|") (re.union (str.to_re "1") (re.union (str.to_re "|") (re.union (str.to_re "2") (re.union (str.to_re "|") (re.union (str.to_re "3") (re.union (str.to_re "|") (re.union (str.to_re "4") (re.union (str.to_re "|") (str.to_re "5"))))))))))) ((_ re.loop 2 2) (re.range "0" "9")))))) (re.++ (str.to_re "1") (re.++ (str.to_re ".") (str.to_re "600"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)