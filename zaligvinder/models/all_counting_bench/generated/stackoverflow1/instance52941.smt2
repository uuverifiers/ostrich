;test regex (2010-01-02[^X]{2})|(2010-01-08[^X]{2})|(2010-01-07[^X]{2})|(2010-01-05[^X]{2})|(2010-01-15[^X]{2})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.++ (str.to_re "2010") (re.++ (str.to_re "-") (re.++ (str.to_re "01") (re.++ (str.to_re "-") (re.++ (str.to_re "02") ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "X")))))))) (re.++ (str.to_re "2010") (re.++ (str.to_re "-") (re.++ (str.to_re "01") (re.++ (str.to_re "-") (re.++ (str.to_re "08") ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "X"))))))))) (re.++ (str.to_re "2010") (re.++ (str.to_re "-") (re.++ (str.to_re "01") (re.++ (str.to_re "-") (re.++ (str.to_re "07") ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "X"))))))))) (re.++ (str.to_re "2010") (re.++ (str.to_re "-") (re.++ (str.to_re "01") (re.++ (str.to_re "-") (re.++ (str.to_re "05") ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "X"))))))))) (re.++ (str.to_re "2010") (re.++ (str.to_re "-") (re.++ (str.to_re "01") (re.++ (str.to_re "-") (re.++ (str.to_re "15") ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "X")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)