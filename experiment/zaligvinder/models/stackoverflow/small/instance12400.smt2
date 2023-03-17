;test regex ((\d*|\d*\.\d{0,2})\s?(ml|oz|etc))
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.* (re.range "0" "9")) (re.++ (re.* (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.union (re.union (re.++ (str.to_re "m") (str.to_re "l")) (re.++ (str.to_re "o") (str.to_re "z"))) (re.++ (str.to_re "e") (re.++ (str.to_re "t") (str.to_re "c"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)