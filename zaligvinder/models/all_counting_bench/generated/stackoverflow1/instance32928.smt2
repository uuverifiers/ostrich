;test regex "(([0-9]+[ \t]?)+(\n|\r)?){1,}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.* (re.++ (re.+ (re.++ (re.+ (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}"))))) (re.opt (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))))) ((_ re.loop 1 1) (re.++ (re.+ (re.++ (re.+ (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}"))))) (re.opt (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}")))))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)