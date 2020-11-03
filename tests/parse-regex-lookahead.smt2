(declare-const w String)

(assert (str.in.re w (re.from.str "^(?=.*[A-Z])(?=.*[a-z])(?=.*[\@%\+\/!#$^\?:,\.\(\){}\[\]~\-_`&*])(?=.*\d).{8,32}$")))
(assert (str.contains w "<script>xss(17649646)</script>"))

(check-sat)