;test regex day1otlk_(\d{3,4})\.gif
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (re.++ (str.to_re "1") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "l") (re.++ (str.to_re "k") (re.++ (str.to_re "_") (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (str.to_re "f"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)