;test regex sha1: [a-z0-9]{40}\n
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "1") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ ((_ re.loop 40 40) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)