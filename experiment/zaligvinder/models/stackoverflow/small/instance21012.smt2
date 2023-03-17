;test regex ([leazoscnz]{1})
(declare-const X String)
(assert (str.in_re X ((_ re.loop 1 1) (re.union (str.to_re "l") (re.union (str.to_re "e") (re.union (str.to_re "a") (re.union (str.to_re "z") (re.union (str.to_re "o") (re.union (str.to_re "s") (re.union (str.to_re "c") (re.union (str.to_re "n") (str.to_re "z"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)