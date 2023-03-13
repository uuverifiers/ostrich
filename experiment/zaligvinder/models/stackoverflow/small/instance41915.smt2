;test regex ^([\u{20}-\u{21}\u{23}-\u{25}\u{28}-\x2E\u{30}-\x3B\x3F-\x7E\xA0-\xFF]){0,40}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 0 40) (re.union (re.range "\u{20}" "\u{21}") (re.union (re.range "\u{23}" "\u{25}") (re.union (re.range "\u{28}" "\u{2e}") (re.union (re.range "\u{30}" "\u{3b}") (re.union (re.range "\u{3f}" "\u{7e}") (re.range "\u{a0}" "\u{ff}")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)