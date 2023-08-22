;test regex (?:\?from=pubapi_\w{5})?
(declare-const X String)
(assert (str.in_re X (re.opt (re.++ (str.to_re "?") (re.++ (str.to_re "f") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "=") (re.++ (str.to_re "p") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "p") (re.++ (str.to_re "i") (re.++ (str.to_re "_") ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)