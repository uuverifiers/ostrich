(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; sidesearch\.dropspam\.com\s+Strip-Player\s+
(assert (str.in_re X (re.++ (str.to_re "sidesearch.dropspam.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Strip-Player\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; <a\s*href=(.*?)[\s|>]
(assert (str.in_re X (re.++ (str.to_re "<a") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "href=") (re.* re.allchar) (re.union (str.to_re "|") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
; (^1300\d{6}$)|(^1800|1900|1902\d{6}$)|(^0[2|3|7|8]{1}[0-9]{8}$)|(^13\d{4}$)|(^04\d{2,3}\d{6}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "1300") ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "|") (str.to_re "3") (str.to_re "7") (str.to_re "8"))) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (str.to_re "13") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}04") ((_ re.loop 2 3) (re.range "0" "9")) ((_ re.loop 6 6) (re.range "0" "9"))) (str.to_re "1800") (str.to_re "1900") (re.++ (str.to_re "1902") ((_ re.loop 6 6) (re.range "0" "9"))))))
; ^\d{1,2}\.\d{3}\.\d{3}[-][0-9kK]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.union (re.range "0" "9") (str.to_re "k") (str.to_re "K"))) (str.to_re "\u{0a}"))))
; [\u{00}-\x1F\x7F]
(assert (not (str.in_re X (re.++ (re.union (re.range "\u{00}" "\u{1f}") (str.to_re "\u{7f}")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
