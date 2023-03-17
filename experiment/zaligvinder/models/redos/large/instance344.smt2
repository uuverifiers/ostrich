;test regex \A(sha256:)?[0-9a-f]{64}\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.opt (re.++ (str.to_re "s") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "256") (str.to_re ":")))))) (re.++ ((_ re.loop 64 64) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)