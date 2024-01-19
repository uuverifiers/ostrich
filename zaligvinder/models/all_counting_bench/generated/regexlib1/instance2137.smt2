;test regex 714|760|949|619|909|951|818|310|323|213|323|562|626-\d{3}-\d{4}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "714") (str.to_re "760")) (str.to_re "949")) (str.to_re "619")) (str.to_re "909")) (str.to_re "951")) (str.to_re "818")) (str.to_re "310")) (str.to_re "323")) (str.to_re "213")) (str.to_re "323")) (str.to_re "562")) (re.++ (str.to_re "626") (re.++ (str.to_re "-") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)