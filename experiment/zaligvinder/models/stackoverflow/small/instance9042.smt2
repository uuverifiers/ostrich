;test regex (?:(504|621)9(\d{12}|(\-\d{4}){3}|(\s\d{4}){3}))
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "504") (str.to_re "621")) (re.++ (str.to_re "9") (re.union (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 3 3) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))) ((_ re.loop 3 3) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) ((_ re.loop 4 4) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)