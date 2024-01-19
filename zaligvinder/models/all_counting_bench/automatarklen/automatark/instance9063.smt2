(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}maki/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".maki/i\u{0a}"))))
; /\/3\/[A-Z]{2}\/[a-f0-9]{32}\sHTTP/
(assert (str.in_re X (re.++ (str.to_re "//3/") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "HTTP/\u{0a}"))))
; Ready\s+Client\dFrom\x3AWebtool\x2Eworld2\x2EcnUser-Agent\x3AUser-Agent\u{3a}URLencoderthis\x7CConnected
(assert (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Client") (re.range "0" "9") (str.to_re "From:Webtool.world2.cn\u{13}User-Agent:User-Agent:URLencoderthis|Connected\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
