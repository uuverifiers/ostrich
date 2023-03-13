(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\"http:\/\/www\.youtube\.com\/v\/\w{11}\&rel\=1\")
(assert (str.in_re X (re.++ (str.to_re "\u{0a}\u{22}http://www.youtube.com/v/") ((_ re.loop 11 11) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "&rel=1\u{22}"))))
; [1-2][0|9][0-9]{2}[0-1][0-9][0-3][0-9][-][0-9]{4}
(assert (not (str.in_re X (re.++ (re.range "1" "2") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "1") (re.range "0" "9") (re.range "0" "3") (re.range "0" "9") (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; on\dName=Your\+Host\+is\x3AcdpViewHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "on") (re.range "0" "9") (str.to_re "Name=Your+Host+is:cdpViewHost:User-Agent:\u{0a}")))))
; ixqshv\u{2f}qzccsMM_RECO\x2EEXE%3fwwwwp-includes\x2Ftheme\x2Ephp\x3F
(assert (not (str.in_re X (str.to_re "ixqshv/qzccsMM_RECO.EXE%3fwwwwp-includes/theme.php?\u{0a}"))))
; /[0-9a-fA-F]{8}[a-z]{6}.php/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 6 6) (re.range "a" "z")) re.allchar (str.to_re "php/\u{0a}"))))
(check-sat)
