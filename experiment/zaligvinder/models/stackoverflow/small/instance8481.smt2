;test regex @"^(\\d{5}(-\\d{4})?|[a-z]\\d[a-z][- ]*\\d[a-z]\\d)$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.union (re.++ (str.to_re "\\") (re.++ ((_ re.loop 5 5) (str.to_re "d")) (re.opt (re.++ (str.to_re "-") (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d"))))))) (re.++ (re.range "a" "z") (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (re.range "a" "z") (re.++ (re.* (re.union (str.to_re "-") (str.to_re " "))) (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (re.range "a" "z") (re.++ (str.to_re "\\") (str.to_re "d"))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)