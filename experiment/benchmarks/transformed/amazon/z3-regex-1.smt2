(declare-const S String)

; S not in aaabbb*

(assert (not (str.in.re S (re.++ (str.to.re "aaabbb") re.all ))))

; S in aaa*bbb*


(assert (str.in.re S (re.++ (re.++ (re.++
 (str.to.re "aaa") re.all )
 (str.to.re "bbb")) re.all )))

(check-sat) ; should be SAT
(get-model)
(get-info :reason-unknown)
