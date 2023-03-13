(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (str.in_re X (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}")))
; /^(\d{1,2})(\/)(\d{1,2})(\/)(\d{4})(T|\s{1,2})(([0-1][0-9])|(2[0-3])):([0-5][0-9])+$/;
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "T") ((_ re.loop 1 2) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.+ (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "/;\u{0a}"))))
(check-sat)
