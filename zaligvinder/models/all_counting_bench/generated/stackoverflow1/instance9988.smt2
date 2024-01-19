;test regex ^([A-Z]([a-z.]{1,}\s?)){2,}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.++ (re.range "A" "Z") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (str.to_re "."))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (str.to_re ".")))) (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))) ((_ re.loop 2 2) (re.++ (re.range "A" "Z") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (str.to_re "."))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (str.to_re ".")))) (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)