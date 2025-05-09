(declare-const x String)
(declare-const y String)

(assert (= y (str.replace_cg_all
               x
               (re.++
                 (re.+ (str.to.re "a"))
                 re.end-anchor)
               (str.to.re "b"))))

(assert (= y "cb"))
(assert (str.in.re x
                   (re.++
                     re.all
                     (str.to.re "a")
                     (re.+
                       (str.to.re "a"))
                     re.all)))

(check-sat)
(get-model)
