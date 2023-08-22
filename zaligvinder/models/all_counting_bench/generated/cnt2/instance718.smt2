;test regex ^[a-f0-9]{256}:[a-f0-9]{256}:[a-f0-9]{16}:[a-f0-9]{16}:[a-f0-9]{320}:[a-f0-9]{16}:[a-f0-9]{40}:[a-f0-9]{40}:[a-f0-9]{40}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 256 256) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ ((_ re.loop 256 256) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ ((_ re.loop 320 320) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ":") (re.++ ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ":") ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9")))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)