;test regex "^M{0,3}(CM)?D{0,3}(CD)?C{0,3}(XC)?L{0,3}(XL)?X{0,3}(IX)?V{0,3}(IV)?I{0,3}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 0 3) (str.to_re "M")) (re.++ (re.opt (re.++ (str.to_re "C") (str.to_re "M"))) (re.++ ((_ re.loop 0 3) (str.to_re "D")) (re.++ (re.opt (re.++ (str.to_re "C") (str.to_re "D"))) (re.++ ((_ re.loop 0 3) (str.to_re "C")) (re.++ (re.opt (re.++ (str.to_re "X") (str.to_re "C"))) (re.++ ((_ re.loop 0 3) (str.to_re "L")) (re.++ (re.opt (re.++ (str.to_re "X") (str.to_re "L"))) (re.++ ((_ re.loop 0 3) (str.to_re "X")) (re.++ (re.opt (re.++ (str.to_re "I") (str.to_re "X"))) (re.++ ((_ re.loop 0 3) (str.to_re "V")) (re.++ (re.opt (re.++ (str.to_re "I") (str.to_re "V"))) ((_ re.loop 0 3) (str.to_re "I")))))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)