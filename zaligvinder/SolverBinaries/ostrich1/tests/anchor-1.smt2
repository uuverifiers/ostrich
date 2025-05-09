(declare-const x String)
(declare-const y String)

(assert (= y (str.replace_cg_all
               x
               (re.++
                 re.begin-anchor
                 (re.+ (str.to.re "a")))
               (str.to.re "b"))))

(assert (= y "bc"))
(assert (str.in.re x
                   (re.++
                     re.all
                     (str.to.re "a")
                     (re.+
                       (str.to.re "a"))
                     re.all)))
;(assert (not (str.contains y "aa")))

(check-sat)
(get-model)
