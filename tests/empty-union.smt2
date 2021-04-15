(declare-fun TestC0 () String)
(declare-fun |18 Fill 1| () String)
(declare-fun |18 Fill 0| () String)
(declare-fun |18 Fill 2| () String)
(assert (let ((a!1 (re.union (re.range "a" "z")
                     (re.range "A" "Z")
                     (re.range "0" "9")
                     (str.to.re "_"))))
(let ((a!2 
                           (re.complement a!1))
      (a!3 (re.inter (str.to.re "Giggles")
                     (re.++ a!1 (re.* (re.range "\x00" "\xff")))))
      )
(let ((a!6 (re.++ (re.union a!2 (str.to.re "")) )
                     ))
  (str.in.re TestC0 
                      a!6 
                    )))))

(check-sat)
(get-model)