;test regex ^[0-9]{6} (blob|tree) ([0-9a-f]{40})\t(.+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.union (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (str.to_re "b")))) (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (str.to_re "e"))))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "\u{09}") (re.+ (re.diff re.allchar (str.to_re "\n")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)