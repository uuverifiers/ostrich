(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}lzh([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.lzh") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(102[0-3]|10[0-1]\d|[1-9][0-9]{0,2}|0)$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "102") (re.range "0" "3")) (re.++ (str.to_re "10") (re.range "0" "1") (re.range "0" "9")) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "0")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}wma/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wma/i\u{0a}"))))
; <!--.*?-->
(assert (str.in_re X (re.++ (str.to_re "<!--") (re.* re.allchar) (str.to_re "-->\u{0a}"))))
; frame_ver2\s+www\u{2e}urlblaze\u{2e}net\s+source\=IncrediFind\s+AgentHost\x3AHost\x3AHost\x3A\x2FGRSpynova3AFrom\x3A
(assert (not (str.in_re X (re.++ (str.to_re "frame_ver2") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.urlblaze.net") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "source=IncrediFind") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AgentHost:Host:Host:/GRSpynova3AFrom:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
