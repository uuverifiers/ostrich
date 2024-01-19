(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A.*User-Agent\u{3a}\sRequest
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Request\u{0a}"))))
; ^ *([AaBbCcEeGgHhJjKkLlMmNnPpRrSsTtVvXxYy]\d[a-zA-Z]) *-* *(\d[a-zA-Z]\d) *$|^ *(\d{5}) *$|^ *(\d{5}) *-* *(\d{4}) *$
(assert (not (str.in_re X (re.union (re.++ (re.* (str.to_re " ")) (re.* (str.to_re " ")) (re.* (str.to_re "-")) (re.* (str.to_re " ")) (re.* (str.to_re " ")) (re.union (str.to_re "A") (str.to_re "a") (str.to_re "B") (str.to_re "b") (str.to_re "C") (str.to_re "c") (str.to_re "E") (str.to_re "e") (str.to_re "G") (str.to_re "g") (str.to_re "H") (str.to_re "h") (str.to_re "J") (str.to_re "j") (str.to_re "K") (str.to_re "k") (str.to_re "L") (str.to_re "l") (str.to_re "M") (str.to_re "m") (str.to_re "N") (str.to_re "n") (str.to_re "P") (str.to_re "p") (str.to_re "R") (str.to_re "r") (str.to_re "S") (str.to_re "s") (str.to_re "T") (str.to_re "t") (str.to_re "V") (str.to_re "v") (str.to_re "X") (str.to_re "x") (str.to_re "Y") (str.to_re "y")) (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")) (re.++ (re.* (str.to_re " ")) ((_ re.loop 5 5) (re.range "0" "9")) (re.* (str.to_re " "))) (re.++ (re.* (str.to_re " ")) ((_ re.loop 5 5) (re.range "0" "9")) (re.* (str.to_re " ")) (re.* (str.to_re "-")) (re.* (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")) (re.* (str.to_re " ")) (str.to_re "\u{0a}"))))))
; Host\x3A[^\n\r]*\x2Fbar_pl\x2Fshdoclc\.fcgi
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "/bar_pl/shdoclc.fcgi\u{0a}"))))
; cyber@yahoo\x2Ecom\s+Host\u{3a}\x7D\x7Crichfind\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "cyber@yahoo.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:}|richfind.com\u{0a}"))))
; /filename=[^\n]*\u{2e}xbm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xbm/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
