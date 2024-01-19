;test regex @.*?([^.]+[.]\w{3}|[^.]+[.]k12[.]il[.]us)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "@") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ (re.+ (re.diff re.allchar (str.to_re "."))) (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (re.++ (re.+ (re.diff re.allchar (str.to_re "."))) (re.++ (str.to_re ".") (re.++ (str.to_re "k") (re.++ (str.to_re "12") (re.++ (str.to_re ".") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re ".") (re.++ (str.to_re "u") (str.to_re "s"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)