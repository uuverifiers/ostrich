;test regex ^(GB)?(\ )?[0-9]\d{2}(\ )?[0-9]\d{3}(\ )?(0[0-9]|[1-8][0-9]|9[0-6])(\ )?([0-9]\d{2})?|(GB)?(\ )?GD(\ )?([0-4][0-9][0-9])|(GB)?(\ )?HA(\ )?([5-9][0-9][0-9])$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "") (re.++ (re.opt (re.++ (str.to_re "G") (str.to_re "B"))) (re.++ (re.opt (str.to_re " ")) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (re.range "1" "8") (re.range "0" "9"))) (re.++ (str.to_re "9") (re.range "0" "6"))) (re.++ (re.opt (str.to_re " ")) (re.opt (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9"))))))))))))))) (re.++ (re.opt (re.++ (str.to_re "G") (str.to_re "B"))) (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re "G") (re.++ (str.to_re "D") (re.++ (re.opt (str.to_re " ")) (re.++ (re.range "0" "4") (re.++ (re.range "0" "9") (re.range "0" "9"))))))))) (re.++ (re.++ (re.opt (re.++ (str.to_re "G") (str.to_re "B"))) (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re "H") (re.++ (str.to_re "A") (re.++ (re.opt (str.to_re " ")) (re.++ (re.range "5" "9") (re.++ (re.range "0" "9") (re.range "0" "9")))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)