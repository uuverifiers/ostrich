;test regex [+0-9\u0660-\u0669\u06F0-\u06F9]+(?:\.[0-9\u0660-\u0669\u06F0-\u06F9]*)?[0-9\u0660-\u0669\u06F0-\u06F9]{5,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "+") (re.union (re.range "0" "9") (re.union (re.range "\u{0660}" "\u{0669}") (re.range "\u{06f0}" "\u{06f9}"))))) (re.++ (re.opt (re.++ (str.to_re ".") (re.* (re.union (re.range "0" "9") (re.union (re.range "\u{0660}" "\u{0669}") (re.range "\u{06f0}" "\u{06f9}")))))) (re.++ (re.* (re.union (re.range "0" "9") (re.union (re.range "\u{0660}" "\u{0669}") (re.range "\u{06f0}" "\u{06f9}")))) ((_ re.loop 5 5) (re.union (re.range "0" "9") (re.union (re.range "\u{0660}" "\u{0669}") (re.range "\u{06f0}" "\u{06f9}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)