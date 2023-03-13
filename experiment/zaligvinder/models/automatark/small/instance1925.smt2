(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [A-Za-z0-9]{3}
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /filename\s*=\s*[^\r\n]*?\u{2e}ttf[\u{22}\u{27}\u{3b}\s\r\n]/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ".ttf") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ";") (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/i\u{0a}")))))
; www\x2Eweepee\x2Ecom\s+www\x2Ewebfringe\x2Ecomwww\.123mania\.com\x2F0409
(assert (not (str.in_re X (re.++ (str.to_re "www.weepee.com\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.webfringe.comwww.123mania.com/0409\u{0a}")))))
; User-Agent\x3AUser-Agent\u{3a}URLencoderthis\x7CConnected
(assert (str.in_re X (str.to_re "User-Agent:User-Agent:URLencoderthis|Connected\u{0a}")))
(check-sat)
