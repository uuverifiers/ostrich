(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\+?36)?[ -]?(\d{1,2}|(\(\d{1,2}\)))/?([ -]?\d){6,7}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (str.to_re "36"))) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "(") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ")"))) (re.opt (str.to_re "/")) ((_ re.loop 6 7) (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; DA\dwww\x2Ee-finder\x2Ecc.*User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "DA") (re.range "0" "9") (str.to_re "www.e-finder.cc") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}"))))
; SI\|Server\|\d+informationWinInetEvilFTPOSSProxy\x5Chome\/lordofsearch
(assert (not (str.in_re X (re.++ (str.to_re "SI|Server|\u{13}") (re.+ (re.range "0" "9")) (str.to_re "informationWinInetEvilFTPOSSProxy\u{5c}home/lordofsearch\u{0a}")))))
; ^([1-9]+\d{0,2},(\d{3},)*\d{3}(\.\d{1,2})?|[1-9]+\d*(\.\d{1,2})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.+ (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; /[^imsxeADSUXu]([imsxeADSUXu]*)$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "i") (str.to_re "m") (str.to_re "s") (str.to_re "x") (str.to_re "e") (str.to_re "A") (str.to_re "D") (str.to_re "S") (str.to_re "U") (str.to_re "X") (str.to_re "u")) (re.* (re.union (str.to_re "i") (str.to_re "m") (str.to_re "s") (str.to_re "x") (str.to_re "e") (str.to_re "A") (str.to_re "D") (str.to_re "S") (str.to_re "U") (str.to_re "X") (str.to_re "u"))) (str.to_re "/\u{0a}")))))
(check-sat)
