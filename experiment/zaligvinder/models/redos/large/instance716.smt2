;test regex ^[a-f0-9]{130}(:[a-f0-9]{40})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 130 130) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)