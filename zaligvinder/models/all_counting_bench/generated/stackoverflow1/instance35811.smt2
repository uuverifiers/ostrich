;test regex ^(\d{2,3}h\s+\d{1,2}m)|(\d{1,2}m\s+\d{2,3}h)$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re "h") (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "m")))))) (re.++ (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "m") (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re "h"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)