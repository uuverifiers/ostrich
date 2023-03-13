(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(\u{75}|\u{2d}|\u{2f}|\u{73}|\u{a2}|\u{2e}|\u{24}|\u{74})/sR
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "u") (str.to_re "-") (str.to_re "/") (str.to_re "s") (str.to_re "\u{a2}") (str.to_re ".") (str.to_re "$") (str.to_re "t")) (str.to_re "/sR\u{0a}"))))
; Host\x3AInformationwww\x2Ezhongsou\x2EcomLitequick\x2Eqsrch\x2Ecom
(assert (not (str.in_re X (str.to_re "Host:Informationwww.zhongsou.comLitequick.qsrch.com\u{0a}"))))
; ^[a-zA-Z]{4}[a-zA-Z]{2}[a-zA-Z0-9]{2}[XXX0-9]{0,3}
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 0 3) (re.union (str.to_re "X") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; s/\b(\w+)\b/ucfirst($1)/ge
(assert (not (str.in_re X (re.++ (str.to_re "s/") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/ucfirst1/ge\u{0a}")))))
(check-sat)
