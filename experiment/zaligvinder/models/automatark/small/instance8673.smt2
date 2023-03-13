(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}torrent/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".torrent/i\u{0a}"))))
; ^([0-1][0-9]|2[0-3]){1}:([0-5][0-9]){1}:([0-5][0-9]){1},([0-9][0-9][0-9]){1} --> ([0-1][0-9]|2[0-3]){1}:([0-5][0-9]){1}:([0-5][0-9]){1},([0-9][0-9][0-9]){1}(.*)$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 1 1) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re " --> ") ((_ re.loop 1 1) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 1 1) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (re.* re.allchar) (str.to_re "\u{0a}"))))
; http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (str.in_re X (str.to_re "http://tv.seekmo.com/showme.aspx?keyword=\u{0a}")))
(check-sat)
