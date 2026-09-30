(declare-const w String)

(assert
  (str.in.re w
    (re.from.str "(?=(a|aa))\\1")
  )
)

(check-sat)