;test regex re = /^\d{4}\/(10|11|12|\d)\/((1|2)?\d|30|31)$/;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "/")))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (re.union (re.union (re.union (str.to_re "10") (str.to_re "11")) (str.to_re "12")) (re.range "0" "9")) (re.++ (str.to_re "/") (re.union (re.union (re.++ (re.opt (re.union (str.to_re "1") (str.to_re "2"))) (re.range "0" "9")) (str.to_re "30")) (str.to_re "31")))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)