;test regex (\+61 )?(?:0|\(0\))?[2378] (?:[\s-]*\d){8}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "+") (re.++ (str.to_re "61") (str.to_re " ")))) (re.++ (re.opt (re.union (str.to_re "0") (re.++ (str.to_re "(") (re.++ (str.to_re "0") (str.to_re ")"))))) (re.++ (str.to_re "2378") (re.++ (str.to_re " ") ((_ re.loop 8 8) (re.++ (re.* (re.union (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (str.to_re "-"))) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)