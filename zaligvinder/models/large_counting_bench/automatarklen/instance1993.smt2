(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; PASSW=\w+www2\u{2e}instantbuzz\u{2e}com\s+Online
(assert (not (str.in_re X (re.++ (str.to_re "PASSW=") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www2.instantbuzz.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Online\u{0a}")))))
; /[a-z\d\u{2f}\u{2b}\u{3d}]{100}/AGPi
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 100 100) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "/") (str.to_re "+") (str.to_re "="))) (str.to_re "/AGPi\u{0a}")))))
; /\u{2e}xspf([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.xspf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; protocolhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (not (str.in_re X (str.to_re "protocolhttp://www.searchinweb.com/search.php?said=bar\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
