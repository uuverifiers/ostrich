(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\s+GET.*toowww\.123mania\.com
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "GET") (re.* re.allchar) (str.to_re "toowww.123mania.com\u{0a}")))))
; /\u{2e}tga([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.tga") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; http\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (not (str.in_re X (str.to_re "http://www.searchinweb.com/search.php?said=bar\u{0a}"))))
; ^((4(\d{12}|\d{15}))|(5\d{15})|(6011\d{12})|(3(4|7)\d{13}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "4") (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 15 15) (re.range "0" "9")))) (re.++ (str.to_re "5") ((_ re.loop 15 15) (re.range "0" "9"))) (re.++ (str.to_re "6011") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "4") (str.to_re "7")) ((_ re.loop 13 13) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
