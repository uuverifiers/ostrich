;test regex $all=~s/((\n($chars{50,}\=*\n){0,20000})+)($chars+\=*\n)//seg;
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "=") (re.++ (str.to_re "~") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.+ (re.++ (str.to_re "\u{0a}") ((_ re.loop 0 20000) (re.++ (str.to_re "") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (re.++ (re.* (str.to_re "s")) ((_ re.loop 50 50) (str.to_re "s"))) (re.++ (re.* (str.to_re "=")) (str.to_re "\u{0a}"))))))))))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (re.+ (str.to_re "s")) (re.++ (re.* (str.to_re "=")) (str.to_re "\u{0a}")))))))) (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (str.to_re ";"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)