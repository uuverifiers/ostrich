(set-logic QF_S)

(declare-const x String)
(declare-const y String)

(assert (= y (str.replace_cg x (re.from.ecma2020 'a([a-z]*)z')
                               (_ re.reference 1)
                               ; not working yet:
                               ; (re.from.ecma2020 '\1')
                               )))
(assert (str.contains x 'abcz'))

(check-sat)
