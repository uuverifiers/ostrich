;test regex (^|,?\s*)([A-Z]+(_[A-Z]+){2,})(,?\s*|$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "") (re.++ (re.opt (str.to_re ",")) (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))) (re.++ (re.++ (re.+ (re.range "A" "Z")) (re.++ (re.* (re.++ (str.to_re "_") (re.+ (re.range "A" "Z")))) ((_ re.loop 2 2) (re.++ (str.to_re "_") (re.+ (re.range "A" "Z")))))) (re.union (re.++ (re.opt (str.to_re ",")) (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (str.to_re ""))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)