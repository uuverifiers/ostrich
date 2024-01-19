(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [A-Za-z]{1,2}[\d]{1,2}[A-Za-z]{0,1}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; <[iI][fF][rR][aA][mM][eE]([^>]*[^/>]*[/>]*[>])
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.union (str.to_re "i") (str.to_re "I")) (re.union (str.to_re "f") (str.to_re "F")) (re.union (str.to_re "r") (str.to_re "R")) (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "e") (str.to_re "E")) (str.to_re "\u{0a}") (re.* (re.comp (str.to_re ">"))) (re.* (re.union (str.to_re "/") (str.to_re ">"))) (re.* (re.union (str.to_re "/") (str.to_re ">"))) (str.to_re ">")))))
; ^ *(1[0-2]|[1-9]):[0-5][0-9] *(a|p|A|P)(m|M) *$
(assert (not (str.in_re X (re.++ (re.* (str.to_re " ")) (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (re.* (str.to_re " ")) (re.union (str.to_re "a") (str.to_re "p") (str.to_re "A") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")) (re.* (str.to_re " ")) (str.to_re "\u{0a}")))))
; ([^a-zA-Z0-9])
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
