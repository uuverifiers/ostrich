

(declare-const w String)

(assert (str.in.re w
          (re.++ re.begin-anchor (re.+ (re.range "a" "z")) re.end-anchor)))

(check-sat)
