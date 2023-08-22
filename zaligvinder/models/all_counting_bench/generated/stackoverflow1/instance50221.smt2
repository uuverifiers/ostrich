;test regex "12,a,{3,4},b,c"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (str.to_re "12")) (re.++ (str.to_re ",") (str.to_re "a"))) ((_ re.loop 3 4) (str.to_re ","))) (re.++ (str.to_re ",") (str.to_re "b"))) (re.++ (str.to_re ",") (re.++ (str.to_re "c") (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)