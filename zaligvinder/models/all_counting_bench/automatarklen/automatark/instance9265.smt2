(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([a-h,A-H,j-n,J-N,p-z,P-Z,0-9]{9})([a-h,A-H,j-n,J-N,p,P,r-t,R-T,v-z,V-Z,0-9])([a-h,A-H,j-n,J-N,p-z,P-Z,0-9])(\d{6}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 9 9) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (re.range "p" "z") (re.range "P" "Z") (re.range "0" "9"))) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (str.to_re "p") (str.to_re "P") (re.range "r" "t") (re.range "R" "T") (re.range "v" "z") (re.range "V" "Z") (re.range "0" "9")) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (re.range "p" "z") (re.range "P" "Z") (re.range "0" "9")) ((_ re.loop 6 6) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
