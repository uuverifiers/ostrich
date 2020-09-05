

(declare-const x String)
(declare-const y String)

(assert (= y (str.replace_cg_all x
                                 ((_ re.capture 1) (re.range "a" "z"))
                                 (re.++ (_ re.reference 1) (_ re.reference 1)))))

(check-sat)
(get-model)
