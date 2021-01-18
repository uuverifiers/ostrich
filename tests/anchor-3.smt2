(declare-const x String)
(declare-const y String)

; a more tricky example where ^ occurs in a star
; (^a)+ => b
(assert (= y (str.replace_cg_all
               x
               (re.+ (re.++
                       re.begin-anchor
                       (str.to.re "a")))
               (str.to.re "b"))))

(assert (= y "bc"))

; suppose x has at least two consecutive 'a's
; but because of ^, the star can only match once
; making this unsat.
(assert (str.in.re x
                   (re.++
                     re.all
                     (str.to.re "a")
                     (re.+
                       (str.to.re "a"))
                     re.all)))

(check-sat)
(get-model)
