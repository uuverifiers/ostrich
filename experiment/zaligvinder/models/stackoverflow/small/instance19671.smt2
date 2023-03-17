;test regex \d(,)\d|\d([ ]{1,},[ ]{0,})\d|\d([ ]{1,})\d
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.range "0" "9") (re.++ (str.to_re ",") (re.range "0" "9"))) (re.++ (re.range "0" "9") (re.++ (re.++ (re.++ (re.* (str.to_re " ")) ((_ re.loop 1 1) (str.to_re " "))) (re.++ (str.to_re ",") (re.++ (re.* (str.to_re " ")) ((_ re.loop 0 0) (str.to_re " "))))) (re.range "0" "9")))) (re.++ (re.range "0" "9") (re.++ (re.++ (re.* (str.to_re " ")) ((_ re.loop 1 1) (str.to_re " "))) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)