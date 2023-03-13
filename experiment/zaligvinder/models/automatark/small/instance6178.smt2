(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; RunnerHost\u{3a}\x2Ehtmldll\x3FCenterspasSubject\x3AHost\x3AconnectedNodes\u{26}Name=
(assert (str.in_re X (str.to_re "RunnerHost:.htmldll?CenterspasSubject:Host:connectedNodes&Name=\u{0a}")))
; Toolbar[^\n\r]*User-Agent\x3A\w+Host\x3A.*toX-Mailer\u{3a}Logsmax-Cookie\u{3a}AppName
(assert (not (str.in_re X (re.++ (str.to_re "Toolbar") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "toX-Mailer:\u{13}Logsmax-Cookie:AppName\u{0a}")))))
; ^(A[A-HJ-M]|[BR][A-Y]|C[A-HJ-PR-V]|[EMOV][A-Y]|G[A-HJ-O]|[DFHKLPSWY][A-HJ-PR-Y]|MAN|N[A-EGHJ-PR-Y]|X[A-F]|)(0[02-9]|[1-9][0-9])[A-HJ-P-R-Z]{3}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "A") (re.union (re.range "A" "H") (re.range "J" "M"))) (re.++ (re.union (str.to_re "B") (str.to_re "R")) (re.range "A" "Y")) (re.++ (str.to_re "C") (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "V"))) (re.++ (re.union (str.to_re "E") (str.to_re "M") (str.to_re "O") (str.to_re "V")) (re.range "A" "Y")) (re.++ (str.to_re "G") (re.union (re.range "A" "H") (re.range "J" "O"))) (re.++ (re.union (str.to_re "D") (str.to_re "F") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "P") (str.to_re "S") (str.to_re "W") (str.to_re "Y")) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Y"))) (str.to_re "MAN") (re.++ (str.to_re "N") (re.union (re.range "A" "E") (str.to_re "G") (str.to_re "H") (re.range "J" "P") (re.range "R" "Y"))) (re.++ (str.to_re "X") (re.range "A" "F"))) (re.union (re.++ (str.to_re "0") (re.union (str.to_re "0") (re.range "2" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9"))) ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.range "J" "P") (str.to_re "-") (re.range "R" "Z"))) (str.to_re "\u{0a}")))))
(check-sat)
