;test regex (MSIE\s?)(6|7)[\.0-9]{0,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "M") (re.++ (str.to_re "S") (re.++ (str.to_re "I") (re.++ (str.to_re "E") (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))) (re.++ (re.union (str.to_re "6") (str.to_re "7")) (re.++ (re.* (re.union (str.to_re ".") (re.range "0" "9"))) ((_ re.loop 0 0) (re.union (str.to_re ".") (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)