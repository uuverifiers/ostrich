;test regex (([^0-9=%]|\r\n|\s){10,}[0-9,.]*){2}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 2) (re.++ (re.++ (re.* (re.union (re.union (re.inter (re.diff re.allchar (re.range "0" "9")) (re.inter (re.diff re.allchar (str.to_re "=")) (re.diff re.allchar (str.to_re "%")))) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) ((_ re.loop 10 10) (re.union (re.union (re.inter (re.diff re.allchar (re.range "0" "9")) (re.inter (re.diff re.allchar (str.to_re "=")) (re.diff re.allchar (str.to_re "%")))) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))) (re.* (re.union (re.range "0" "9") (re.union (str.to_re ",") (str.to_re "."))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)