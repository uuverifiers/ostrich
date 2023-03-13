;test regex ([\u{00}-\x7F]|[\xC0-\xDF][\u{80}-\xBF]|[\xE0-\xEF][\u{80}-\xBF]{2}|[\xF0-\xF7][\u{80}-\xBF]{3})|.
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.range "\u{00}" "\u{7f}") (re.++ (re.range "\u{c0}" "\u{df}") (re.range "\u{80}" "\u{bf}"))) (re.++ (re.range "\u{e0}" "\u{ef}") ((_ re.loop 2 2) (re.range "\u{80}" "\u{bf}")))) (re.++ (re.range "\u{f0}" "\u{f7}") ((_ re.loop 3 3) (re.range "\u{80}" "\u{bf}")))) (re.diff re.allchar (str.to_re "\n")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)