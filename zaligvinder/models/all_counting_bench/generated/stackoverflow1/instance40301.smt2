;test regex ^(:[a-z][dfiquv])(:[a-z][dfiquvo])\d{6}(:[abcd])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (str.to_re ":") (re.++ (re.range "a" "z") (re.union (str.to_re "d") (re.union (str.to_re "f") (re.union (str.to_re "i") (re.union (str.to_re "q") (re.union (str.to_re "u") (str.to_re "v")))))))) (re.++ (re.++ (str.to_re ":") (re.++ (re.range "a" "z") (re.union (str.to_re "d") (re.union (str.to_re "f") (re.union (str.to_re "i") (re.union (str.to_re "q") (re.union (str.to_re "u") (re.union (str.to_re "v") (str.to_re "o"))))))))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re ":") (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "c") (str.to_re "d"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)