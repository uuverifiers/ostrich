;test regex "([\\d]+)?(?:\\s?([^,]+)\\,)?(?:\\s?([^,]+)\\,)?(?:\\s?([\\w]{2}))(?:\\s?([\\d]{5}))"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.opt (re.+ (re.union (str.to_re "\\") (str.to_re "d")))) (re.++ (re.opt (re.++ (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (re.+ (re.diff re.allchar (str.to_re ","))) (str.to_re "\\")))) (str.to_re ","))) (re.++ (re.opt (re.++ (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (re.+ (re.diff re.allchar (str.to_re ","))) (str.to_re "\\")))) (str.to_re ","))) (re.++ (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) ((_ re.loop 2 2) (re.union (str.to_re "\\") (str.to_re "w"))))) (re.++ (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) ((_ re.loop 5 5) (re.union (str.to_re "\\") (str.to_re "d"))))) (str.to_re "\u{22}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)