;test regex ^(([\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF]+)\s){3}([\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF]+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.++ (re.+ (re.union (re.range "\u{0600}" "\u{065f}") (re.union (re.range "\u{066a}" "\u{06ef}") (re.range "\u{06fa}" "\u{06ff}")))) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.+ (re.union (re.range "\u{0600}" "\u{065f}") (re.union (re.range "\u{066a}" "\u{06ef}") (re.range "\u{06fa}" "\u{06ff}")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)