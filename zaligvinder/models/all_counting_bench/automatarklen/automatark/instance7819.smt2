(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}pac([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pac") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^213\.61\.220\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])$
(assert (not (str.in_re X (re.++ (str.to_re "213.61.220.") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "8") (str.to_re "+7")) (re.opt (re.union (str.to_re "-") (str.to_re " "))))) (re.opt (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " "))))) ((_ re.loop 7 10) (re.union (re.range "0" "9") (str.to_re "-") (str.to_re " "))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
