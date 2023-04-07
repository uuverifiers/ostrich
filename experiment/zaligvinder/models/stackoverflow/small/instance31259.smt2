;test regex (^(?:[^\|\n]*\|){1,21}[^\|\n]+)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 1 21) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "|")) (re.diff re.allchar (str.to_re "\u{0a}")))) (str.to_re "|"))) (re.+ (re.inter (re.diff re.allchar (str.to_re "|")) (re.diff re.allchar (str.to_re "\u{0a}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)