;test regex \A([0-9a-f]{128})\ +[!-~]+\n\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ ((_ re.loop 128 128) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (re.+ (str.to_re " ")) (re.++ (re.+ (re.union (str.to_re "!") (re.union (str.to_re "-") (str.to_re "~")))) (re.++ (str.to_re "\u{0a}") (str.to_re "z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)