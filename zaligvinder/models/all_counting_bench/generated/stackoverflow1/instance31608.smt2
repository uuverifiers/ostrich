;test regex ^(.+?)\h{2}(\d{4,5})\h+(.+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (str.to_re "h")) (re.++ ((_ re.loop 4 5) (re.range "0" "9")) (re.++ (re.+ (str.to_re "h")) (re.+ (re.diff re.allchar (str.to_re "\n")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)