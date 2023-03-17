;test regex ^[a-z\xE4\xF6\xFC]*[A-Z\xC4\xD6\xDC]([A-Z\xC4\xD6\xDC\xDF]+|[a-z\xE4\xF6\xFC\xDF]{3,})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re "\u{e4}") (re.union (str.to_re "\u{f6}") (str.to_re "\u{fc}"))))) (re.++ (re.union (re.range "A" "Z") (re.union (str.to_re "\u{c4}") (re.union (str.to_re "\u{d6}") (str.to_re "\u{dc}")))) (re.union (re.+ (re.union (re.range "A" "Z") (re.union (str.to_re "\u{c4}") (re.union (str.to_re "\u{d6}") (re.union (str.to_re "\u{dc}") (str.to_re "\u{df}")))))) (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re "\u{e4}") (re.union (str.to_re "\u{f6}") (re.union (str.to_re "\u{fc}") (str.to_re "\u{df}")))))) ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.union (str.to_re "\u{e4}") (re.union (str.to_re "\u{f6}") (re.union (str.to_re "\u{fc}") (str.to_re "\u{df}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)