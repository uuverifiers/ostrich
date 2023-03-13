(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; url=\"([^\[\]\"]*)\"
(assert (not (str.in_re X (re.++ (str.to_re "url=\u{22}") (re.* (re.union (str.to_re "[") (str.to_re "]") (str.to_re "\u{22}"))) (str.to_re "\u{22}\u{0a}")))))
; www\x2Eweepee\x2Ecom\w+Owner\x3A\d+metaresults\.copernic\.com
(assert (str.in_re X (re.++ (str.to_re "www.weepee.com\u{1b}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.+ (re.range "0" "9")) (str.to_re "metaresults.copernic.com\u{0a}"))))
; sidesearch\.dropspam\.com\s+Strip-Player\s+
(assert (str.in_re X (re.++ (str.to_re "sidesearch.dropspam.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Strip-Player\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; [-]?[1-9]\d{0,16}\.?\d{0,2}|[-]?[0]?\.[1-9]{1,2}|[-]?[0]?\.[0-9][1-9]
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) (re.range "1" "9") ((_ re.loop 0 16) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "0")) (str.to_re ".") ((_ re.loop 1 2) (re.range "1" "9"))) (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "0")) (str.to_re ".") (re.range "0" "9") (re.range "1" "9") (str.to_re "\u{0a}"))))))
(check-sat)
