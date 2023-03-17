;test regex "^([A-Za-z][0-9])(\\w{7,})*"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9")) (re.++ (re.* (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "w")) ((_ re.loop 7 7) (str.to_re "w"))))) (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)