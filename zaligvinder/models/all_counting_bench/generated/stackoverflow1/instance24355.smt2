;test regex ([\\s\\S]*?)(grp2=\"\\S*?\")(?:([\\s\\S]*?)(grp4=\"\\S*?\")){0,1}([\\s\\S]*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "\\") (re.union (str.to_re "s") (re.union (str.to_re "\\") (str.to_re "S"))))) (re.++ (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "p") (re.++ (str.to_re "2") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "S")) (str.to_re "\u{22}"))))))))) (re.++ ((_ re.loop 0 1) (re.++ (re.* (re.union (str.to_re "\\") (re.union (str.to_re "s") (re.union (str.to_re "\\") (str.to_re "S"))))) (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "p") (re.++ (str.to_re "4") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "S")) (str.to_re "\u{22}"))))))))))) (re.* (re.union (str.to_re "\\") (re.union (str.to_re "s") (re.union (str.to_re "\\") (str.to_re "S"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)