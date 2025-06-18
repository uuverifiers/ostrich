(declare-const x String)

(assert (= "hhhh" (str.replace_re x (re.+ (str.to_re "h")) "hhh")))
(assert (= 2 (str.len x)))

(check-sat)
(get-model)