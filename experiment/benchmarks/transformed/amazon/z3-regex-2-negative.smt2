(declare-const S String)

; S in aaabbb*

(assert (str.in.re S (re.++ (str.to.re "aaabbb") re.all )))

; S not in aaa*bbb*


(assert (not (str.in.re S (re.++ (re.++
 (re.++ (str.to.re "aaa") re.all )
 (str.to.re "bbb"))
 re.all ))))

(check-sat) ; should be UNSAT
(get-model)
