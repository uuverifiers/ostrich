;test regex .{0,24}\u{20}\u{20}\u{20}\u{20}\u{20}\u{20}\u{20}\u{20}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 24) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") (str.to_re "\u{20}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)