(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(3[0-1]|2[0-9]|1[0-9]|0[1-9])[\/](Jan|JAN|Feb|FEB|Mar|MAR|Apr|APR|May|MAY|Jun|JUN|Jul|JUL|Aug|AUG|Sep|SEP|Oct|OCT|Nov|NOV|Dec|DEC)[\/]\d{4}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9"))) (str.to_re "/") (re.union (str.to_re "Jan") (str.to_re "JAN") (str.to_re "Feb") (str.to_re "FEB") (str.to_re "Mar") (str.to_re "MAR") (str.to_re "Apr") (str.to_re "APR") (str.to_re "May") (str.to_re "MAY") (str.to_re "Jun") (str.to_re "JUN") (str.to_re "Jul") (str.to_re "JUL") (str.to_re "Aug") (str.to_re "AUG") (str.to_re "Sep") (str.to_re "SEP") (str.to_re "Oct") (str.to_re "OCT") (str.to_re "Nov") (str.to_re "NOV") (str.to_re "Dec") (str.to_re "DEC")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^POST\u{20}\u{2f}[A-F\d]{42}\u{20}HTTP/
(assert (str.in_re X (re.++ (str.to_re "/POST /") ((_ re.loop 42 42) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re " HTTP/\u{0a}"))))
; /\x2Fmrow\x5Fpin\x2F\x3Fid\d+[a-z]{5,}\d{5}\u{26}rnd\x3D\d+/smi
(assert (str.in_re X (re.++ (str.to_re "//mrow_pin/?id") (re.+ (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "&rnd=") (re.+ (re.range "0" "9")) (str.to_re "/smi\u{0a}") ((_ re.loop 5 5) (re.range "a" "z")) (re.* (re.range "a" "z")))))
(check-sat)
