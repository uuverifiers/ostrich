(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\(\d{3}\)[- ]?|\d{3}[- ])?\d{3}[- ]\d{4}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (re.union (str.to_re "-") (str.to_re " ")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " "))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; asdbiz\x2Ebiz\s+informationHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "asdbiz.biz") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "informationHost:\u{0a}")))))
; /^\d{0,10}_passes_\d{1,10}\.xm/iR
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 0 10) (re.range "0" "9")) (str.to_re "_passes_") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".xm/iR\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
