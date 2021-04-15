

(declare-const w String)

(assert (str.in_re w (re.* (str.to_re "abc"))))
(assert (str.in_re w (re.+ (str.to_re "abc"))))

(check-sat)
