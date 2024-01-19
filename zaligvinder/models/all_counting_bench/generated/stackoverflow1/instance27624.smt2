;test regex ^(?:[\u0000-\u02AF]|[\u0302\u030C]|[\u1E00-\u1EFF]){2,}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.union (re.union (re.range "\u{0000}" "\u{02af}") (re.union (str.to_re "\u{0302}") (str.to_re "\u{030c}"))) (re.range "\u{1e00}" "\u{1eff}"))) ((_ re.loop 2 2) (re.union (re.union (re.range "\u{0000}" "\u{02af}") (re.union (str.to_re "\u{0302}") (str.to_re "\u{030c}"))) (re.range "\u{1e00}" "\u{1eff}"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)