(declare-fun x () String)
(declare-fun y () String)
(declare-fun x1 () String)
(declare-fun y1 () String)
(declare-fun z () String)
(declare-fun w () String)
(declare-fun v () String)

(assert (= x (str.replaceallre y (str.to.re "010") z)))
(assert (= y (str.replaceallre w (str.to.re "1") v)))
(assert (= w (str.replaceallre x1 (str.to.re "00") y1)))

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
(assert (str.in.re w (re.* (str.to.re "1"))))
(assert (str.in.re x1 (re.* (str.to.re "0"))))

(check-sat)
