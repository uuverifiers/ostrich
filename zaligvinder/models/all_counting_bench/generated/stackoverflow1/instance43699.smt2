;test regex ^(([a-fA-F0-9]{2}-){5}[a-fA-F0-9]{2}|([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}|([0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.opt (re.union (re.union (re.++ ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (str.to_re "-"))) ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9"))))) (re.++ ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (str.to_re ":"))) ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))))) (re.++ ((_ re.loop 2 2) (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f")))) (str.to_re "."))) ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)