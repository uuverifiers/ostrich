;test regex ([a-ceghj-nprstv-z][0-9]){3}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 3 3) (re.++ (re.union (re.range "a" "c") (re.union (str.to_re "e") (re.union (str.to_re "g") (re.union (str.to_re "h") (re.union (re.range "j" "n") (re.union (str.to_re "p") (re.union (str.to_re "r") (re.union (str.to_re "s") (re.union (str.to_re "t") (re.range "v" "z")))))))))) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)