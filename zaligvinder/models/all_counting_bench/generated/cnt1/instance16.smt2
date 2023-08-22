;test regex ^.{24}.{0,17}\u{4e}\u{41}\u{4d}\u{45}\u{4e}\u{41}\u{4d}\u{45}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 24 24) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 0 17) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{4e}") (re.++ (str.to_re "\u{41}") (re.++ (str.to_re "\u{4d}") (re.++ (str.to_re "\u{45}") (re.++ (str.to_re "\u{4e}") (re.++ (str.to_re "\u{41}") (re.++ (str.to_re "\u{4d}") (str.to_re "\u{45}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)