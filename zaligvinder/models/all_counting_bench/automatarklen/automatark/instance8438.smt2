(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x7D\x7BUser\x3A\x7D\x7BTrojan\x3ASPYSubject\x3A\swww\.fast-finder\.comhostieLogger
(assert (not (str.in_re X (re.++ (str.to_re "}{User:}{Trojan:SPYSubject:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.comhostieLogger\u{0a}")))))
; ([ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ])\ ?([0-9][ABCEGHJKLMNPRSTVWXYZ][0-9])
(assert (not (str.in_re X (re.++ (re.opt (str.to_re " ")) (str.to_re "\u{0a}") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "V") (str.to_re "X") (str.to_re "Y")) (re.range "0" "9") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "V") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z")) (re.range "0" "9") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "V") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z")) (re.range "0" "9")))))
; ^([0-9]{1,2},([0-9]{2},)*[0-9]{3}|[0-9]+)$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; fsbuffshprrprt-cs-Host\x3A
(assert (not (str.in_re X (str.to_re "fsbuffshprrprt-cs-\u{13}Host:\u{0a}"))))
; <[^>]*name[\s]*=[\s]*"?[^\w_]*"?[^>]*>
(assert (str.in_re X (re.++ (str.to_re "<") (re.* (re.comp (str.to_re ">"))) (str.to_re "name") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "\u{22}")) (re.* (re.union (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re "\u{22}")) (re.* (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
