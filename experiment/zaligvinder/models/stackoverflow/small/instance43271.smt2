;test regex ^((?:[^|]*\|){2})([^|]*)\|(.*?AKS_PN)\|(.*)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.++ (re.* (re.diff re.allchar (str.to_re "|"))) (str.to_re "|"))) (re.++ (re.* (re.diff re.allchar (str.to_re "|"))) (re.++ (str.to_re "|") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "A") (re.++ (str.to_re "K") (re.++ (str.to_re "S") (re.++ (str.to_re "_") (re.++ (str.to_re "P") (str.to_re "N"))))))) (re.++ (str.to_re "|") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)