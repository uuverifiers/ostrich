;test regex \u{20}\u{20}\u{20}.{2}\u{20}.{3}\u{20}\u{20}.{32}\u{20}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{20}") (re.++ ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{20}") (re.++ (str.to_re "\u{20}") (re.++ ((_ re.loop 32 32) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{20}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)