;test regex 192\.168\.[1|2|5|20]\.[0-9]{1,3}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "192") (re.++ (str.to_re ".") (re.++ (str.to_re "168") (re.++ (str.to_re ".") (re.++ (re.union (str.to_re "1") (re.union (str.to_re "|") (re.union (str.to_re "2") (re.union (str.to_re "|") (re.union (str.to_re "5") (re.union (str.to_re "|") (str.to_re "20"))))))) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)