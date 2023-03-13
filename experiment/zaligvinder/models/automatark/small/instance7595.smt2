(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]{1,2}[0-9][0-9A-Za-z]{0,1} {0,1}[0-9][A-Za-z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.range "0" "9") (re.opt (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re " ")) (re.range "0" "9") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; .*[Vv][Ii1]agr.*
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "V") (str.to_re "v")) (re.union (str.to_re "I") (str.to_re "i") (str.to_re "1")) (str.to_re "agr") (re.* re.allchar) (str.to_re "\u{0a}")))))
; User-Agent\x3A\s+www\x2Ewordiq\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.wordiq.com\u{1b}\u{0a}"))))
; ^(\+?\d{1,2}[ -]?)?(\(\+?\d{2,3}\)|\+?\d{2,3})?[ -]?\d{3,4}[ -]?\d{3,4}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))))) (re.opt (re.union (re.++ (str.to_re "(") (re.opt (str.to_re "+")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ")")) (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 3) (re.range "0" "9"))))) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 3 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[0-9]{2}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
