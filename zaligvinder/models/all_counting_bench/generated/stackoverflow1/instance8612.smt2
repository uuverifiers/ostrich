;test regex ^[0]{6}|[1]{6}|[2]{6}|[3]{6}|[4]{6}|[5]{6}|[6]{6}|[7]{6}|[8]{6}|[9]{6}$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "") ((_ re.loop 6 6) (str.to_re "0"))) ((_ re.loop 6 6) (str.to_re "1"))) ((_ re.loop 6 6) (str.to_re "2"))) ((_ re.loop 6 6) (str.to_re "3"))) ((_ re.loop 6 6) (str.to_re "4"))) ((_ re.loop 6 6) (str.to_re "5"))) ((_ re.loop 6 6) (str.to_re "6"))) ((_ re.loop 6 6) (str.to_re "7"))) ((_ re.loop 6 6) (str.to_re "8"))) (re.++ ((_ re.loop 6 6) (str.to_re "9")) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)