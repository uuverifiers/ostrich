(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]([a-zA-Z0-9])*([\.][a-zA-Z]([a-zA-Z0-9])*)*$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; /^\u{2f}[0-9a-z]{30}$/Umi
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 30 30) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "/Umi\u{0a}")))))
; .*[Pp]re[Ss\$]cr[iI1]pt.*
(assert (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "P") (str.to_re "p")) (str.to_re "re") (re.union (str.to_re "S") (str.to_re "s") (str.to_re "$")) (str.to_re "cr") (re.union (str.to_re "i") (str.to_re "I") (str.to_re "1")) (str.to_re "pt") (re.* re.allchar) (str.to_re "\u{0a}"))))
; addrwww\x2Etrustedsearch\x2EcomX-Mailer\x3A
(assert (str.in_re X (str.to_re "addrwww.trustedsearch.comX-Mailer:\u{13}\u{0a}")))
(check-sat)
