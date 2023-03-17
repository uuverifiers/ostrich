;test regex [SELECT]{6}[ ]{0,50}[@clnt_id_n]{10}[ \t]{0,50}[=]{1}[ \t]{0,50}[0-9]{2,10}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.union (str.to_re "S") (re.union (str.to_re "E") (re.union (str.to_re "L") (re.union (str.to_re "E") (re.union (str.to_re "C") (str.to_re "T"))))))) (re.++ ((_ re.loop 0 50) (str.to_re " ")) (re.++ ((_ re.loop 10 10) (re.union (str.to_re "@") (re.union (str.to_re "c") (re.union (str.to_re "l") (re.union (str.to_re "n") (re.union (str.to_re "t") (re.union (str.to_re "_") (re.union (str.to_re "i") (re.union (str.to_re "d") (re.union (str.to_re "_") (str.to_re "n"))))))))))) (re.++ ((_ re.loop 0 50) (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.++ ((_ re.loop 1 1) (str.to_re "=")) (re.++ ((_ re.loop 0 50) (re.union (str.to_re " ") (str.to_re "\u{09}"))) ((_ re.loop 2 10) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)