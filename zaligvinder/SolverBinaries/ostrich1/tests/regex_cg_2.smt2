

(declare-const x String)
(declare-const y String)

(assert (= y (str.replace_cg x
                                 ((_ re.capture 1) (re.range "a" "z"))
                                 (re.++ (_ re.reference 1) (_ re.reference 1)))))
(assert (str.contains x "a"))
(assert (not (str.contains y "aa")))

(check-sat)
(get-model)
