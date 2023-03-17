;test regex regexp_matches(string, '.*(FD)([0-9]{6})(\.)?.*') as sqn
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re "_") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "g")))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (str.to_re "F") (str.to_re "D")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.opt (str.to_re ".")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{27}")))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "q") (str.to_re "n"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)