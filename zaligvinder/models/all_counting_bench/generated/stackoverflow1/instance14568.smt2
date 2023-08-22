;test regex (<a[^>]+?style=".*?color:#(\w{6}).*?".*?>)(.+?)(<\/a>)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "<") (re.++ (str.to_re "a") (re.++ (re.+ (re.diff re.allchar (str.to_re ">"))) (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "y") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re ":") (re.++ (str.to_re "#") (re.++ ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re ">"))))))))))))))))))))))) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (str.to_re ">"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)