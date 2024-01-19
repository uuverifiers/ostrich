;test regex <a.*?news/.*?/(\d{1,4}\/[01]?\d)?.*?</a>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ (str.to_re "a") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re "w") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "/") (re.++ (re.opt (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (re.opt (str.to_re "01")) (re.range "0" "9"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (str.to_re ">"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)