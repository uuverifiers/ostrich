(declare-const x String)
(declare-const y String)
(declare-const z String)
(declare-const w String)
(declare-const v String)

(assert (= x (str.replace_re_longest_all y (str.to.re "0101") z)))
(assert (= z (str.replace_re_longest_all v (str.to.re "1111") w)))

(assert 
(str.in.re x 
(re.++ 
    (re.* (re.union (str.to.re "0") (str.to.re "1") ) )
    (re.union 
        (re.++ (str.to.re "00") (re.* (re.union (str.to.re "0")(str.to.re "1") ) ) )
        (re.++ (str.to.re "11") (re.* (re.union (str.to.re "0")(str.to.re "1") ) ) )
    )
) 
)
)
(assert (str.in.re y (re.* (str.to.re "01"))))
(assert (str.in.re z (re.* (str.to.re "10"))))

(check-sat)
