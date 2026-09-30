(set-logic QF_S)

(declare-const w String)

(assert
  (str.in_re w
    (re.from_ecma2020
      " *(https?:\/\/)?(www\.)?[-a-za-z0-9@:%._\+~#=]{1,256}\.[a-za-z0-9()]{1,24}\b([-a-za-z0-9()@:%_\+.~#?&//=]*) *"
    )
  )
)

(check-sat)