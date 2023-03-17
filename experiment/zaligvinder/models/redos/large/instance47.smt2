;test regex ^.{0,92}\u{38}\u{39}\u{3a}\u{3b}\u{3c}\u{3d}\u{3e}\u{3f}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 0 92) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{38}") (re.++ (str.to_re "\u{39}") (re.++ (str.to_re "\u{3a}") (re.++ (str.to_re "\u{3b}") (re.++ (str.to_re "\u{3c}") (re.++ (str.to_re "\u{3d}") (re.++ (str.to_re "\u{3e}") (str.to_re "\u{3f}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)