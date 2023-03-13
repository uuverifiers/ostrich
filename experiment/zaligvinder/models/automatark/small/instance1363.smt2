(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Client.*Peer\s+ThistoIpHost\x3Abadurl\x2Egrandstreetinteractive\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Client") (re.* re.allchar) (str.to_re "Peer") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ThistoIpHost:badurl.grandstreetinteractive.com\u{0a}"))))
; ^[0-9]+$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; %[\-\+0\s\#]{0,1}(\d+){0,1}(\.\d+){0,1}[hlI]{0,1}[cCdiouxXeEfgGnpsS]{1}
(assert (not (str.in_re X (re.++ (str.to_re "%") (re.opt (re.union (str.to_re "-") (str.to_re "+") (str.to_re "0") (str.to_re "#") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (re.opt (re.union (str.to_re "h") (str.to_re "l") (str.to_re "I"))) ((_ re.loop 1 1) (re.union (str.to_re "c") (str.to_re "C") (str.to_re "d") (str.to_re "i") (str.to_re "o") (str.to_re "u") (str.to_re "x") (str.to_re "X") (str.to_re "e") (str.to_re "E") (str.to_re "f") (str.to_re "g") (str.to_re "G") (str.to_re "n") (str.to_re "p") (str.to_re "s") (str.to_re "S"))) (str.to_re "\u{0a}")))))
; ^[^\"]+$
(assert (str.in_re X (re.++ (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{0a}"))))
; ^(A[A-HJ-M]|[BR][A-Y]|C[A-HJ-PR-V]|[EMOV][A-Y]|G[A-HJ-O]|[DFHKLPSWY][A-HJ-PR-Y]|MAN|N[A-EGHJ-PR-Y]|X[A-F]|)(0[02-9]|[1-9][0-9])[A-HJ-P-R-Z]{3}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "A") (re.union (re.range "A" "H") (re.range "J" "M"))) (re.++ (re.union (str.to_re "B") (str.to_re "R")) (re.range "A" "Y")) (re.++ (str.to_re "C") (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "V"))) (re.++ (re.union (str.to_re "E") (str.to_re "M") (str.to_re "O") (str.to_re "V")) (re.range "A" "Y")) (re.++ (str.to_re "G") (re.union (re.range "A" "H") (re.range "J" "O"))) (re.++ (re.union (str.to_re "D") (str.to_re "F") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "P") (str.to_re "S") (str.to_re "W") (str.to_re "Y")) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Y"))) (str.to_re "MAN") (re.++ (str.to_re "N") (re.union (re.range "A" "E") (str.to_re "G") (str.to_re "H") (re.range "J" "P") (re.range "R" "Y"))) (re.++ (str.to_re "X") (re.range "A" "F"))) (re.union (re.++ (str.to_re "0") (re.union (str.to_re "0") (re.range "2" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9"))) ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.range "J" "P") (str.to_re "-") (re.range "R" "Z"))) (str.to_re "\u{0a}"))))
(check-sat)
