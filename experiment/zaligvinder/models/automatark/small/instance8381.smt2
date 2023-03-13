(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+\x2Ftoolbar\x2Fico\x2F\dencoderserverreport\<\x2Ftitle\>
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/ico/") (re.range "0" "9") (str.to_re "encoderserverreport</title>\u{0a}")))))
; ^.+@[^\.].*\.[a-z]{2,}$
(assert (not (str.in_re X (re.++ (re.+ re.allchar) (str.to_re "@") (re.comp (str.to_re ".")) (re.* re.allchar) (str.to_re ".\u{0a}") ((_ re.loop 2 2) (re.range "a" "z")) (re.* (re.range "a" "z"))))))
; User-Agent\x3AUser-Agent\x3Awww\.take5bingo\.comUser-Agent\x3A
(assert (str.in_re X (str.to_re "User-Agent:User-Agent:www.take5bingo.com\u{1b}User-Agent:\u{0a}")))
(check-sat)
