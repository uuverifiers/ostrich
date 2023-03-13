(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z,#/ \.\(\)\-\+\*]*[0-9]){7}[0-9a-zA-Z,#/ \.\(\)\-\+\*]*$
(assert (not (str.in_re X (re.++ ((_ re.loop 7 7) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re ",") (str.to_re "#") (str.to_re "/") (str.to_re " ") (str.to_re ".") (str.to_re "(") (str.to_re ")") (str.to_re "-") (str.to_re "+") (str.to_re "*"))) (re.range "0" "9"))) (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re ",") (str.to_re "#") (str.to_re "/") (str.to_re " ") (str.to_re ".") (str.to_re "(") (str.to_re ")") (str.to_re "-") (str.to_re "+") (str.to_re "*"))) (str.to_re "\u{0a}")))))
; www\.thecommunicator\.net\d+http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (not (str.in_re X (re.++ (str.to_re "www.thecommunicator.net") (re.+ (re.range "0" "9")) (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}")))))
(check-sat)
