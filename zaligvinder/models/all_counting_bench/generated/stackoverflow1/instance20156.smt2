;test regex ^(.){1};(\d){4};(\d){8};[A,K]{1};(\d){7,8};(\d){8};[A-Z ]{1,};( \d){1};(\d){8};(\d){1};(\d){1};$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ";") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re ";") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re ";") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "A") (re.union (str.to_re ",") (str.to_re "K")))) (re.++ (str.to_re ";") (re.++ ((_ re.loop 7 8) (re.range "0" "9")) (re.++ (str.to_re ";") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re ";") (re.++ (re.++ (re.* (re.union (re.range "A" "Z") (str.to_re " "))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (str.to_re " ")))) (re.++ (str.to_re ";") (re.++ ((_ re.loop 1 1) (re.++ (str.to_re " ") (re.range "0" "9"))) (re.++ (str.to_re ";") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re ";") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re ";") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ";"))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)