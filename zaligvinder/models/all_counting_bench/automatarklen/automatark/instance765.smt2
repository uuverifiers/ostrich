(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[1-9][0-9][0-9][0-9][0-9][0-9]$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "1" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (str.to_re "/\u{0a}"))))
; ^(?-i:A[LKSZRAEP]|C[AOT]|D[EC]|F[LM]|G[AU]|HI|I[ADLN]|K[SY]|LA|M[ADEHINOPST]|N[CDEHJMVY]|O[HKR]|P[ARW]|RI|S[CD]|T[NX]|UT|V[AIT]|W[AIVY])$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "A") (re.union (str.to_re "L") (str.to_re "K") (str.to_re "S") (str.to_re "Z") (str.to_re "R") (str.to_re "A") (str.to_re "E") (str.to_re "P"))) (re.++ (str.to_re "C") (re.union (str.to_re "A") (str.to_re "O") (str.to_re "T"))) (re.++ (str.to_re "D") (re.union (str.to_re "E") (str.to_re "C"))) (re.++ (str.to_re "F") (re.union (str.to_re "L") (str.to_re "M"))) (re.++ (str.to_re "G") (re.union (str.to_re "A") (str.to_re "U"))) (str.to_re "HI") (re.++ (str.to_re "I") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "L") (str.to_re "N"))) (re.++ (str.to_re "K") (re.union (str.to_re "S") (str.to_re "Y"))) (str.to_re "LA") (re.++ (str.to_re "M") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "E") (str.to_re "H") (str.to_re "I") (str.to_re "N") (str.to_re "O") (str.to_re "P") (str.to_re "S") (str.to_re "T"))) (re.++ (str.to_re "N") (re.union (str.to_re "C") (str.to_re "D") (str.to_re "E") (str.to_re "H") (str.to_re "J") (str.to_re "M") (str.to_re "V") (str.to_re "Y"))) (re.++ (str.to_re "O") (re.union (str.to_re "H") (str.to_re "K") (str.to_re "R"))) (re.++ (str.to_re "P") (re.union (str.to_re "A") (str.to_re "R") (str.to_re "W"))) (str.to_re "RI") (re.++ (str.to_re "S") (re.union (str.to_re "C") (str.to_re "D"))) (re.++ (str.to_re "T") (re.union (str.to_re "N") (str.to_re "X"))) (str.to_re "UT") (re.++ (str.to_re "V") (re.union (str.to_re "A") (str.to_re "I") (str.to_re "T"))) (re.++ (str.to_re "W") (re.union (str.to_re "A") (str.to_re "I") (str.to_re "V") (str.to_re "Y")))) (str.to_re "\u{0a}"))))
; ovpl\w+UBAgent%3fSchwindlerurl=Host\u{3a}httpUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "ovpl") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "UBAgent%3fSchwindlerurl=Host:httpUser-Agent:\u{0a}")))))
; ^(\d{1,})$|^(\d{1,}\.)$|^(\d{0,}?\.\d{1,})$|^([+-]\d{1,}(\.)?)$|^([+-](\d{1,})?\.\d{1,})$
(assert (str.in_re X (re.union (re.+ (re.range "0" "9")) (re.++ (re.+ (re.range "0" "9")) (str.to_re ".")) (re.++ (re.* (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9"))) (re.++ (re.union (str.to_re "+") (str.to_re "-")) (re.+ (re.range "0" "9")) (re.opt (str.to_re "."))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "+") (str.to_re "-")) (re.opt (re.+ (re.range "0" "9"))) (str.to_re ".") (re.+ (re.range "0" "9"))))))
; ^(389)[0-9]{11}$
(assert (str.in_re X (re.++ (str.to_re "389") ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
