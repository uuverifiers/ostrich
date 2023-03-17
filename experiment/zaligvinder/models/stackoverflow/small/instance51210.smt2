;test regex q(\d+)([M]|[T]|[W]|[TH]|[F]|[S]|[SU]){1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "q") (re.++ (re.+ (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "M") (str.to_re "T")) (str.to_re "W")) (re.union (str.to_re "T") (str.to_re "H"))) (str.to_re "F")) (str.to_re "S")) (re.union (str.to_re "S") (str.to_re "U"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)