(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[2-9]{2}[0-9]{8}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "2" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}chm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.chm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^((\d|\d\d|[0-1]\d\d|2[0-4]\d|25[0-5])\.(\d|\d\d|[0-1]\d\d|2[0-4]\d|25[0-5])\.(\d|\d\d|[0-1]\d\d|2[0-4]\d|25[0-5])\.(\d|\d\d|[0-1]\d\d|2[0-4]\d|25[0-5]))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ".") (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ".") (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ".") (re.union (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")))))))
; /\u{40}\u{40}\u{40}([0-9A-Z]{2}\x2D){5}[0-9A-Z]{2}/iP
(assert (not (str.in_re X (re.++ (str.to_re "/@@@") ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (str.to_re "-"))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (str.to_re "/iP\u{0a}")))))
; ^1+0+$
(assert (not (str.in_re X (re.++ (re.+ (str.to_re "1")) (re.+ (str.to_re "0")) (str.to_re "\u{0a}")))))
(check-sat)
