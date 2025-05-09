(set-logic QF_S)

(declare-const w String)

; (assert (= (str.in_re w (re.from.ecma2020 '[a-z]'))
;            (str.in_re w (re.range "a" "z"))))


;(assert (str.in.re w (re.from.ecma2020 '[^a-c]')))
;(assert (str.in.re w (re.from.ecma2020 'a\D\s\wb.c[a-z][b-c]{5,10}')))

; (assert (str.in.re w (re.from.ecma2020 '.\w+\s\w+[\sa-z](a|b)\t\cg')))

; (assert (str.in.re w (re.from.ecma2020 '(?:\^|\\A)(.*)(?:\$|\\z)')))
; (assert (= (str.len w) 10))
;(assert (str.in.re w (re.from.ecma2020 '''\/\xFF[a-zA-Z\\]*')))
; (assert (str.in.re w (re.from.ecma2020 '(?=.*[a-z])X.*[A-Z].*')))

; (assert (str.in.re w (re.from.ecma2020 '^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).*$')))

(assert (str.in.re w (re.from.ecma2020 ' *')))
; (assert (str.contains w "-"))


(check-sat)
(get-model)


