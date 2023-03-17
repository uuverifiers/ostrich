;test regex ^[a-zA-Z\u00C5\u00C6\u00D8\u00E5\u00E6\u00F8\!\-\?\""\. ]{3,999}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 3 999) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "\u{00c5}") (re.union (str.to_re "\u{00c6}") (re.union (str.to_re "\u{00d8}") (re.union (str.to_re "\u{00e5}") (re.union (str.to_re "\u{00e6}") (re.union (str.to_re "\u{00f8}") (re.union (str.to_re "!") (re.union (str.to_re "-") (re.union (str.to_re "?") (re.union (str.to_re "\u{22}") (re.union (str.to_re "\u{22}") (re.union (str.to_re ".") (str.to_re " "))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)