(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/stat_d\/$/U
(assert (str.in_re X (str.to_re "//stat_d//U\u{0a}")))
; (DK-?)?([0-9]{2}\ ?){3}[0-9]{2}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "DK") (re.opt (str.to_re "-")))) ((_ re.loop 3 3) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "V") (str.to_re "X") (str.to_re "Y"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) (re.* (str.to_re " ")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; PL\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}|PL\d{26}
(assert (str.in_re X (re.++ (str.to_re "PL") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 26 26) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; Port\x2E[^\n\r]*007\d+Logsdl\x2Eweb-nexus\x2Enet
(assert (str.in_re X (re.++ (str.to_re "Port.") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "007") (re.+ (re.range "0" "9")) (str.to_re "Logsdl.web-nexus.net\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
