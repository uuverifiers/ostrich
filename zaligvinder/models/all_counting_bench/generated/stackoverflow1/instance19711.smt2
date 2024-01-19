;test regex ^1\|dc35_custom(?:\|([2-9]|1[01]);[a-z]{2};[A-Z]{1,3};[A-Z]{1,2}){9}\|$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "|") (re.++ (str.to_re "d") (re.++ (str.to_re "c") (re.++ (str.to_re "35") (re.++ (str.to_re "_") (re.++ (str.to_re "c") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ ((_ re.loop 9 9) (re.++ (str.to_re "|") (re.++ (re.union (re.range "2" "9") (re.++ (str.to_re "1") (str.to_re "01"))) (re.++ (str.to_re ";") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re ";") (re.++ ((_ re.loop 1 3) (re.range "A" "Z")) (re.++ (str.to_re ";") ((_ re.loop 1 2) (re.range "A" "Z")))))))))) (str.to_re "|"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)