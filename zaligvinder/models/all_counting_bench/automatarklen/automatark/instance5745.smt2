(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(3[0-1]|2[0-9]|1[0-9]|0[1-9])[\/](Jan|JAN|Feb|FEB|Mar|MAR|Apr|APR|May|MAY|Jun|JUN|Jul|JUL|Aug|AUG|Sep|SEP|Oct|OCT|Nov|NOV|Dec|DEC)[\/]\d{4}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9"))) (str.to_re "/") (re.union (str.to_re "Jan") (str.to_re "JAN") (str.to_re "Feb") (str.to_re "FEB") (str.to_re "Mar") (str.to_re "MAR") (str.to_re "Apr") (str.to_re "APR") (str.to_re "May") (str.to_re "MAY") (str.to_re "Jun") (str.to_re "JUN") (str.to_re "Jul") (str.to_re "JUL") (str.to_re "Aug") (str.to_re "AUG") (str.to_re "Sep") (str.to_re "SEP") (str.to_re "Oct") (str.to_re "OCT") (str.to_re "Nov") (str.to_re "NOV") (str.to_re "Dec") (str.to_re "DEC")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; MyAgentprotocolprotocolHost\x3A\x2Fs\u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}data2\.activshopper\.com
(assert (not (str.in_re X (str.to_re "MyAgentprotocolprotocolHost:/s(robert@blackcastlesoft.com)data2.activshopper.com\u{0a}"))))
; http://www.mail-password-recovery.com/
(assert (not (str.in_re X (re.++ (str.to_re "http://www") re.allchar (str.to_re "mail-password-recovery") re.allchar (str.to_re "com/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
