;test regex ^([Mm]\d{1} [Ff]?\d{1} [Cc]?\d{1})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "M") (str.to_re "m")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.opt (re.union (str.to_re "F") (str.to_re "f"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.opt (re.union (str.to_re "C") (str.to_re "c"))) ((_ re.loop 1 1) (re.range "0" "9")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)