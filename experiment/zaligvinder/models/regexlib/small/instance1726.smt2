;test regex ^[A-Za-z&#192;-&#214;&#216;-&#246;&#248;-&#255; &#39;\-\.]{1,22}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 1 22) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "192") (re.union (re.range ";" "&") (re.union (str.to_re "#") (re.union (str.to_re "214") (re.union (str.to_re ";") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "216") (re.union (re.range ";" "&") (re.union (str.to_re "#") (re.union (str.to_re "246") (re.union (str.to_re ";") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "248") (re.union (re.range ";" "&") (re.union (str.to_re "#") (re.union (str.to_re "255") (re.union (str.to_re ";") (re.union (str.to_re " ") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "39") (re.union (str.to_re ";") (re.union (str.to_re "-") (str.to_re ".")))))))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)