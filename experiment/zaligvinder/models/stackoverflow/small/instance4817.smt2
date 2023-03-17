;test regex ^\]d2(?:((?:10|21)[a-zA-Z0-9]{1,20}(?:\/:|$))|(01[0-9]{14})|((?:11|15|17)[0-9]{6}))*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "]") (re.++ (str.to_re "d") (re.++ (str.to_re "2") (re.* (re.union (re.union (re.++ (re.union (str.to_re "10") (str.to_re "21")) (re.++ ((_ re.loop 1 20) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.union (re.++ (str.to_re "/") (str.to_re ":")) (str.to_re "")))) (re.++ (str.to_re "01") ((_ re.loop 14 14) (re.range "0" "9")))) (re.++ (re.union (re.union (str.to_re "11") (str.to_re "15")) (str.to_re "17")) ((_ re.loop 6 6) (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)