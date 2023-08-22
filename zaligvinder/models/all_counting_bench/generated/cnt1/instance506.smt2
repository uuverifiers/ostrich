;test regex avocado-vt-joblock-[0-9a-f]{40}-[0-9]+-[0-9a-z]{8}\.pid
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ (str.to_re "v") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "-") (re.++ (str.to_re "v") (re.++ (str.to_re "t") (re.++ (str.to_re "-") (re.++ (str.to_re "j") (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re "-") (re.++ ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "-") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "z"))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "i") (str.to_re "d"))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)