;test regex ^[CGTA]{77}([CGTA]{22})[CGTA]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 77 77) (re.union (str.to_re "C") (re.union (str.to_re "G") (re.union (str.to_re "T") (str.to_re "A"))))) (re.++ ((_ re.loop 22 22) (re.union (str.to_re "C") (re.union (str.to_re "G") (re.union (str.to_re "T") (str.to_re "A"))))) ((_ re.loop 2 2) (re.union (str.to_re "C") (re.union (str.to_re "G") (re.union (str.to_re "T") (str.to_re "A"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)