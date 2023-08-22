(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0[1-9])|(1[0-2]))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "\u{0a}")))))
; ^(A[A-HJ-M]|[BR][A-Y]|C[A-HJ-PR-V]|[EMOV][A-Y]|G[A-HJ-O]|[DFHKLPSWY][A-HJ-PR-Y]|MAN|N[A-EGHJ-PR-Y]|X[A-F]|)(0[02-9]|[1-9][0-9])[A-HJ-P-R-Z]{3}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "A") (re.union (re.range "A" "H") (re.range "J" "M"))) (re.++ (re.union (str.to_re "B") (str.to_re "R")) (re.range "A" "Y")) (re.++ (str.to_re "C") (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "V"))) (re.++ (re.union (str.to_re "E") (str.to_re "M") (str.to_re "O") (str.to_re "V")) (re.range "A" "Y")) (re.++ (str.to_re "G") (re.union (re.range "A" "H") (re.range "J" "O"))) (re.++ (re.union (str.to_re "D") (str.to_re "F") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "P") (str.to_re "S") (str.to_re "W") (str.to_re "Y")) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Y"))) (str.to_re "MAN") (re.++ (str.to_re "N") (re.union (re.range "A" "E") (str.to_re "G") (str.to_re "H") (re.range "J" "P") (re.range "R" "Y"))) (re.++ (str.to_re "X") (re.range "A" "F"))) (re.union (re.++ (str.to_re "0") (re.union (str.to_re "0") (re.range "2" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9"))) ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.range "J" "P") (str.to_re "-") (re.range "R" "Z"))) (str.to_re "\u{0a}"))))
; HWPE[^\n\r]*Basic.*LOGsearches\x2Eworldtostart\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "HWPE") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Basic") (re.* re.allchar) (str.to_re "LOGsearches.worldtostart.com\u{0a}")))))
; (^3[47])((\d{11}$)|(\d{13}$))
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 13) (re.range "0" "9"))) (str.to_re "\u{0a}3") (re.union (str.to_re "4") (str.to_re "7"))))))
; /\/AES\d+O\d+\.jsp\?[a-z0-9=\u{2b}\u{2f}]{20}/iU
(assert (str.in_re X (re.++ (str.to_re "//AES") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
