;test regex [\u{00}-\x1F]|\xC2[\u{80}-\x9F]|\xE2[\u{80}-\x8F]{2}|\xE2\u{80}[\xA4-\xA8]|\xE2\u{81}[\x9F-\xAF]
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.range "\u{00}" "\u{1f}") (re.++ (str.to_re "\u{c2}") (re.range "\u{80}" "\u{9f}"))) (re.++ (str.to_re "\u{e2}") ((_ re.loop 2 2) (re.range "\u{80}" "\u{8f}")))) (re.++ (str.to_re "\u{e2}") (re.++ (str.to_re "\u{80}") (re.range "\u{a4}" "\u{a8}")))) (re.++ (str.to_re "\u{e2}") (re.++ (str.to_re "\u{81}") (re.range "\u{9f}" "\u{af}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)