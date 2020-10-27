(set-logic QF_S)

(declare-const in String)
(declare-const intermediate-1 String)
(declare-const intermediate-2 String)
(declare-const intermediate-3 String)
(declare-const intermediate-4 String)
(declare-const intermediate-5 String)

(assert (= intermediate-1 (str.replaceall in "Attribution" "BY")))

(assert (= intermediate-2 (str.replaceall intermediate-1 "NonCommercial" "NC")))

(assert (= intermediate-3 (str.replaceall intermediate-2 "NoDerivatives" "ND")))

(assert (= intermediate-4 (str.replace_cg_all intermediate-3 
    (re.++ (re.range "-" "-") ((_ re.capture 2) (re.range "0" "9"))) 
    ;((_ re.capture 1) (re.range "0" "9")) 
    (re.++ (str.to.re " ") (_ re.reference 2)))))

(assert (str.in.re in (str.to.re "CC-Attribution-4")))
;(assert (str.in.re intermediate-4 (re.from.str ".*\d")))

(check-sat)
(get-model)
