;test regex "(?:<<:--!!(\\d{6})([a-zA-Z ]+))"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.++ (str.to_re "<") (re.++ (str.to_re "<") (re.++ (str.to_re ":") (re.++ (str.to_re "-") (re.++ (str.to_re "-") (re.++ (str.to_re "!") (re.++ (str.to_re "!") (re.++ (re.++ (str.to_re "\\") ((_ re.loop 6 6) (str.to_re "d"))) (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (str.to_re " ")))))))))))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)