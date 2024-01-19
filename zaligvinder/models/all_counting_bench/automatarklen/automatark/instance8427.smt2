(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9]{4}[A-Z]{2}
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; [v,V,(\\/)](\W|)[i,I,1,l,L](\W|)[a,A,@,(\/\\)](\W|)[g,G](\W|)[r,R](\W|)[a,A,@,(\/\\))]
(assert (str.in_re X (re.++ (re.union (str.to_re "v") (str.to_re ",") (str.to_re "V") (str.to_re "(") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ")")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "i") (str.to_re ",") (str.to_re "I") (str.to_re "1") (str.to_re "l") (str.to_re "L")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "a") (str.to_re ",") (str.to_re "A") (str.to_re "@") (str.to_re "(") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re ")")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "g") (str.to_re ",") (str.to_re "G")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "r") (str.to_re ",") (str.to_re "R")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re "a") (str.to_re ",") (str.to_re "A") (str.to_re "@") (str.to_re "(") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re ")")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
