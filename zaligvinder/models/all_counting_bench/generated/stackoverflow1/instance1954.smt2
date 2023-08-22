;test regex .*baidu.com.*[/?].*[wd|word|qw]{1}=
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "u") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "/") (str.to_re "?")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "w") (re.union (str.to_re "d") (re.union (str.to_re "|") (re.union (str.to_re "w") (re.union (str.to_re "o") (re.union (str.to_re "r") (re.union (str.to_re "d") (re.union (str.to_re "|") (re.union (str.to_re "q") (str.to_re "w"))))))))))) (str.to_re "=")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)