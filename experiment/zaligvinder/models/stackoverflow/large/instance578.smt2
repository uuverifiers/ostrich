;test regex \qdb{123}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "q") (re.++ (str.to_re "d") ((_ re.loop 123 123) (str.to_re "b"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)