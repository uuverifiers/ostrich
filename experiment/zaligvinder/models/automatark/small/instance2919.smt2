(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/3\/[A-Z]{2}\/[a-f0-9]{32}\/\d+\.\d+\.\d+\.\d+\//
(assert (str.in_re X (re.++ (str.to_re "//3/") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re "//\u{0a}"))))
; /\u{2e}mka([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.mka") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; User-Agent\x3AUser-Agent\u{3a}URLencoderthis\x7CConnected
(assert (str.in_re X (str.to_re "User-Agent:User-Agent:URLencoderthis|Connected\u{0a}")))
; whenu\x2Ecom\d+Agent\stoWebupdate\.cgithisHost\u{3a}connection
(assert (not (str.in_re X (re.++ (str.to_re "whenu.com\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "Agent") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toWebupdate.cgithisHost:connection\u{0a}")))))
; /\u{2e}smi([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.smi") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(check-sat)
