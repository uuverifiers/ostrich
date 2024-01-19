;test regex ^A[ \t]{0,1}B[ \t]{0,1}C
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.++ (str.to_re "B") (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (str.to_re "\u{09}"))) (str.to_re "C"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)