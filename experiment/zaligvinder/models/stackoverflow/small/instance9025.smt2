;test regex ^(\\d{6})\\|(\\d{6})\\|(\\d{2})\\|(\\d{2})\\|([a-zA-Z0-9 ]*)$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "\\") ((_ re.loop 6 6) (str.to_re "d"))) (str.to_re "\\"))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 6 6) (str.to_re "d"))) (str.to_re "\\"))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))) (str.to_re "\\"))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))) (str.to_re "\\"))) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re " "))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)