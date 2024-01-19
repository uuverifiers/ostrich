;test regex ^08(17|18|19|31|32|33|38|59|77|78)?[0-9]{0,8}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "08") (re.++ (re.opt (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "17") (str.to_re "18")) (str.to_re "19")) (str.to_re "31")) (str.to_re "32")) (str.to_re "33")) (str.to_re "38")) (str.to_re "59")) (str.to_re "77")) (str.to_re "78"))) ((_ re.loop 0 8) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)