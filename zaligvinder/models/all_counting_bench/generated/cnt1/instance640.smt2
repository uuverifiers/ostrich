;test regex .*[Cc]{2,3}(\d{5,})[CcAa]{3,6}(\d{5,})[CcAa]{2,3}(\d{5,})[Cc]{2,3}.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 3) (re.union (str.to_re "C") (str.to_re "c"))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ ((_ re.loop 3 6) (re.union (str.to_re "C") (re.union (str.to_re "c") (re.union (str.to_re "A") (str.to_re "a"))))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ ((_ re.loop 2 3) (re.union (str.to_re "C") (re.union (str.to_re "c") (re.union (str.to_re "A") (str.to_re "a"))))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ ((_ re.loop 2 3) (re.union (str.to_re "C") (str.to_re "c"))) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)