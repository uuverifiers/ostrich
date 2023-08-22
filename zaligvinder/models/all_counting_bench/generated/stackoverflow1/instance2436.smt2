;test regex ^192\.168(\.(1[0-9][0-9]|200)){2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "192") (re.++ (str.to_re ".") (re.++ (str.to_re "168") ((_ re.loop 2 2) (re.++ (str.to_re ".") (re.union (re.++ (str.to_re "1") (re.++ (re.range "0" "9") (re.range "0" "9"))) (str.to_re "200")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)