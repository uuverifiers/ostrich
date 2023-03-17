;test regex 12345678|[0]{8}|[1]{8}|[2]{8}|[3]{8}|[4]{8}|[5]{8}|[6]{8}|[7]{8}|[8]{8}|[9]{8}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "12345678") ((_ re.loop 8 8) (str.to_re "0"))) ((_ re.loop 8 8) (str.to_re "1"))) ((_ re.loop 8 8) (str.to_re "2"))) ((_ re.loop 8 8) (str.to_re "3"))) ((_ re.loop 8 8) (str.to_re "4"))) ((_ re.loop 8 8) (str.to_re "5"))) ((_ re.loop 8 8) (str.to_re "6"))) ((_ re.loop 8 8) (str.to_re "7"))) ((_ re.loop 8 8) (str.to_re "8"))) ((_ re.loop 8 8) (str.to_re "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)