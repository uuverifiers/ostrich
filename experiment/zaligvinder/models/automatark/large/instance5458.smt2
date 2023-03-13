(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ToolbarBasedATLRemoteFrom\x3Adcww\x2Edmcast\x2Ecom
(assert (str.in_re X (str.to_re "ToolbarBasedATLRemoteFrom:dcww.dmcast.com\u{0a}")))
; User-Agent\x3A.*Host\x3A\dName=Your\+Host\+is\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "Host:") (re.range "0" "9") (str.to_re "Name=Your+Host+is:\u{0a}")))))
; Ready\s+Toolbar\d+ServerLiteToolbar
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "ServerLiteToolbar\u{0a}"))))
; urn:[a-z0-9]{1}[a-z0-9\-]{1,31}:[a-z0-9_,:=@;!'%/#\(\)\+\-\.\$\*\?]+
(assert (not (str.in_re X (re.++ (str.to_re "urn:") ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 1 31) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ":") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ",") (str.to_re ":") (str.to_re "=") (str.to_re "@") (str.to_re ";") (str.to_re "!") (str.to_re "'") (str.to_re "%") (str.to_re "/") (str.to_re "#") (str.to_re "(") (str.to_re ")") (str.to_re "+") (str.to_re "-") (str.to_re ".") (str.to_re "$") (str.to_re "*") (str.to_re "?"))) (str.to_re "\u{0a}")))))
; /User-Agent\u{3a}\u{20}[^\u{0d}\u{0a}]*?\u{3b}U\u{3a}[^\u{0d}\u{0a}]{1,68}\u{3b}rv\u{3a}/H
(assert (str.in_re X (re.++ (str.to_re "/User-Agent: ") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";U:") ((_ re.loop 1 68) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ";rv:/H\u{0a}"))))
(check-sat)
