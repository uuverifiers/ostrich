;test regex [U|u]ploaded by ([A-Z]{2}|[A-Z]{3}),
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (str.to_re "U") (re.union (str.to_re "|") (str.to_re "u"))) (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "y") (re.++ (str.to_re " ") (re.union ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 3 3) (re.range "A" "Z"))))))))))))))) (str.to_re ","))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)