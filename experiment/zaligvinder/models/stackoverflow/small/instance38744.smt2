;test regex var data = "{45}*[52]*{45}*[52]*{45}*[52]*69"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (re.* ((_ re.loop 45 45) (str.to_re "\u{22}"))) (re.++ (re.* ((_ re.loop 45 45) (re.* (str.to_re "52")))) (re.++ (re.* ((_ re.loop 45 45) (re.* (str.to_re "52")))) (re.++ (re.* (str.to_re "52")) (re.++ (str.to_re "69") (str.to_re "\u{22}")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)