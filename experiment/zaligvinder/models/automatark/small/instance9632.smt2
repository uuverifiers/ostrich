(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\{|\[|\().+(\}|\]|\)).+$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "{") (str.to_re "[") (str.to_re "(")) (re.+ re.allchar) (re.union (str.to_re "}") (str.to_re "]") (str.to_re ")")) (re.+ re.allchar) (str.to_re "\u{0a}")))))
; Host\x3A\d+UI2.*areprotocolhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "UI2") (re.* re.allchar) (str.to_re "areprotocolhttp://www.searchinweb.com/search.php?said=bar\u{0a}")))))
; (0?[1-9]|[12][0-9]|3[01])[/ -](0?[1-9]|1[12])[/ -](19[0-9]{2}|[2][0-9][0-9]{2})
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.union (str.to_re "/") (str.to_re " ") (str.to_re "-")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "1") (str.to_re "2")))) (re.union (str.to_re "/") (str.to_re " ") (str.to_re "-")) (re.union (re.++ (str.to_re "19") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
