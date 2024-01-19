(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <[iI][mM][gG]([^>]*[^/>])
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.union (str.to_re "i") (str.to_re "I")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "g") (str.to_re "G")) (str.to_re "\u{0a}") (re.* (re.comp (str.to_re ">"))) (re.union (str.to_re "/") (str.to_re ">"))))))
; /^[A-Z0-9._-]+@[A-Z0-9.-]+\.[A-Z0-9.-]+$/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re ".") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "/i\u{0a}"))))
; ^(\d){8}$
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
