(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[ABCEGHJKLMNPRSTVXYabceghjklmnprstvxy]{1}\d{1}[A-Za-z]{1}\d{1}[A-Za-z]{1}\d{1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "V") (str.to_re "X") (str.to_re "Y") (str.to_re "a") (str.to_re "b") (str.to_re "c") (str.to_re "e") (str.to_re "g") (str.to_re "h") (str.to_re "j") (str.to_re "k") (str.to_re "l") (str.to_re "m") (str.to_re "n") (str.to_re "p") (str.to_re "r") (str.to_re "s") (str.to_re "t") (str.to_re "v") (str.to_re "x") (str.to_re "y"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^\u{2f}[a-z\u{2d}\u{5f}]{90,97}\.php$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 90 97) (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "_"))) (str.to_re ".php/U\u{0a}"))))
; User-Agent\x3Aupgrade\x2Eqsrch\x2Einfo
(assert (not (str.in_re X (str.to_re "User-Agent:upgrade.qsrch.info\u{0a}"))))
; ^[a-zA-Z][a-zA-Z0-9_]+$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "\u{0a}")))))
(check-sat)
