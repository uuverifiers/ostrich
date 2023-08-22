;test regex ^ (?: \d{1,16} | (?: \x0A | \x0D | [\u{20}-\x5A] | \x5F | [\u{61}-\x7A] | \xC2\xA0 | \xCE\xA9 ){1,11} ) $
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (re.union (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 16) (re.range "0" "9")) (str.to_re " "))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 11) (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re " ") (re.++ (str.to_re "\u{0a}") (str.to_re " "))) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{0d}") (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (re.range "\u{20}" "\u{5a}") (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{5f}") (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (re.range "\u{61}" "\u{7a}") (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{c2}") (re.++ (str.to_re "\u{a0}") (str.to_re " "))))) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{ce}") (re.++ (str.to_re "\u{a9}") (str.to_re " ")))))) (str.to_re " ")))) (str.to_re " ")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)