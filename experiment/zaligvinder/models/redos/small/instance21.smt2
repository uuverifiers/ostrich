;test regex ^.{0,24}\u{49}\u{53}\u{53}\u{50}\u{4e}\u{47}\u{52}\u{51}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 0 24) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{49}") (re.++ (str.to_re "\u{53}") (re.++ (str.to_re "\u{53}") (re.++ (str.to_re "\u{50}") (re.++ (str.to_re "\u{4e}") (re.++ (str.to_re "\u{47}") (re.++ (str.to_re "\u{52}") (str.to_re "\u{51}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)