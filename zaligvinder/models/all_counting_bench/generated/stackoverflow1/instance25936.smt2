;test regex (\d{1,10}( \w+){1,10}( ( \w+){1,10})?( \w+){1,10}[,.](( \w+){1,10}(,)? [A-Z]{2}( [0-9]{5})?)?)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (re.++ ((_ re.loop 1 10) (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (re.++ (re.opt (re.++ (str.to_re " ") ((_ re.loop 1 10) (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))) (re.++ ((_ re.loop 1 10) (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (re.++ (re.union (str.to_re ",") (str.to_re ".")) (re.opt (re.++ ((_ re.loop 1 10) (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (re.++ (re.opt (str.to_re ",")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.opt (re.++ (str.to_re " ") ((_ re.loop 5 5) (re.range "0" "9"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)