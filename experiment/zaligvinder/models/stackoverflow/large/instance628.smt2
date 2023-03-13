;test regex '','','{12345678},{87654321}','lk12l1k2l12lkl12lkl121l2lk12'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{27}") (str.to_re "\u{27}")) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (str.to_re "\u{27}")))) (re.++ (str.to_re ",") ((_ re.loop 12345678 12345678) (str.to_re "\u{27}")))) (re.++ ((_ re.loop 87654321 87654321) (str.to_re ",")) (str.to_re "\u{27}"))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "l") (re.++ (str.to_re "k") (re.++ (str.to_re "12") (re.++ (str.to_re "l") (re.++ (str.to_re "1") (re.++ (str.to_re "k") (re.++ (str.to_re "2") (re.++ (str.to_re "l") (re.++ (str.to_re "12") (re.++ (str.to_re "l") (re.++ (str.to_re "k") (re.++ (str.to_re "l") (re.++ (str.to_re "12") (re.++ (str.to_re "l") (re.++ (str.to_re "k") (re.++ (str.to_re "l") (re.++ (str.to_re "121") (re.++ (str.to_re "l") (re.++ (str.to_re "2") (re.++ (str.to_re "l") (re.++ (str.to_re "k") (re.++ (str.to_re "12") (str.to_re "\u{27}"))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)