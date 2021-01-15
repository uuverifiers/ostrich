(declare-const x String)
(declare-const y String)

(assert (= y (str.replace_cg_all
               x
               (re.+ (re.++
                       re.begin-anchor
                       (str.to.re "a")))
               (str.to.re "b"))))

; a modified version of anchor-3
; sat
(assert (str.in.re y
                   (re.++
                     (str.to.re "b")
                     re.all)))

(assert (str.in.re x
                   (re.++
                     re.all
                     (str.to.re "a")
                     (re.+
                       (str.to.re "a"))
                     re.all)))

(check-sat)
(get-model)
