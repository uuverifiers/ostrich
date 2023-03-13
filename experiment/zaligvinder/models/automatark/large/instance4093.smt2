(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-PR-UWYZ]([0-9]([A-HJKSTUW]|[0-9])?|[A-HK-Y][0-9]([ABEHMNPRVWXY]|[0-9])) [0-9][ABD-HJLNP-UW-Z]{2}|GIR 0AA$
(assert (str.in_re X (re.union (re.++ (re.union (re.range "A" "P") (re.range "R" "U") (str.to_re "W") (str.to_re "Y") (str.to_re "Z")) (re.union (re.++ (re.range "0" "9") (re.opt (re.union (re.range "A" "H") (str.to_re "J") (str.to_re "K") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "W") (re.range "0" "9")))) (re.++ (re.union (re.range "A" "H") (re.range "K" "Y")) (re.range "0" "9") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "V") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (re.range "0" "9")))) (str.to_re " ") (re.range "0" "9") ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "B") (re.range "D" "H") (str.to_re "J") (str.to_re "L") (str.to_re "N") (re.range "P" "U") (re.range "W" "Z")))) (str.to_re "GIR 0AA\u{0a}"))))
; www\x2Ealtnet\x2Ecom[^\n\r]*Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www.altnet.com\u{1b}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}")))))
; /^\u{2f}[A-Z\d]{83}\u{3d}[A-Z\d]{10}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 83 83) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 10 10) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; /\u{3d}\u{0a}$/P
(assert (not (str.in_re X (str.to_re "/=\u{0a}/P\u{0a}"))))
; Host\x3AHost\x3AFrom\u{3a}\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furaxbnymomspyo\u{2f}zowy
(assert (str.in_re X (str.to_re "Host:Host:From:\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furaxbnymomspyo/zowy\u{0a}")))
(check-sat)
