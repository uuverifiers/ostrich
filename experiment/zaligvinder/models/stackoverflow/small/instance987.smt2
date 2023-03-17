;test regex \A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.opt (str.to_re "-")))))) (re.++ (re.opt (str.to_re "(")) (re.++ (re.opt ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.opt (str.to_re ")")) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " "))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "z"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)