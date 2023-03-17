;test regex (?:^.{55}\n)+^.{0,54}\.\n
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.++ (str.to_re "") (re.++ ((_ re.loop 55 55) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}")))) (re.++ (str.to_re "") (re.++ ((_ re.loop 0 54) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (str.to_re "\u{0a}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)