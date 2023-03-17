;test regex ^[A-Za-z]{3}\.?[pdf]|[doc]|[html]$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.opt (str.to_re ".")) (re.union (str.to_re "p") (re.union (str.to_re "d") (str.to_re "f")))))) (re.union (str.to_re "d") (re.union (str.to_re "o") (str.to_re "c")))) (re.++ (re.union (str.to_re "h") (re.union (str.to_re "t") (re.union (str.to_re "m") (str.to_re "l")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)